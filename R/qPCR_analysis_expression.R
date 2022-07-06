#' Real-time qPCR relative quantity calculation.
#'
#' @description
#' Calculates the relative quantity of target genes between one control sample and one or more test samples.
#' Based on one or multiple reference genes.
#'
#' @details
#' Applies the Pfaffl calculation method, accounting for different primer efficiencies
#' ([Pfaffl, 2001](https://doi.org/10.1093/nar/29.9.e45)).
#' The common-base calculation method described by [Ganger et al. 2017](https://doi.org/10.1186/s12859-017-1949-5) is followed,
#' which gives identical results to the Pfaffl method.
#' If efficiencies are not entered (`NULL`), it defaults to the delta-delta-Ct method
#' ([Livak & Schmittgen, 2001](https://doi.org/10.1006/meth.2001.1262)).
#'
#' @param unkdata A `data.frame` containing the technical replicate means of the unknown reactions.
#' Result from `qPCR_analysis_unk_rxns` function.
#' @param refgene Character vector with the name(s) of the reference gene(s).
#' @param efficiencies A `data.frame` containing the efficiencies of each primer pair.
#' The `$efficiencies` `data.table` resulting from the `qPCR_analysis_stdcurve` function.
#' Defaults to `NULL`, which assumes all primer pairs' efficiency being equal to 100%.
#' @param control Character. The name of the control sample, against which all other samples will be compared.
#' Defaults to the 1st sample alphabetically.
#'
#' @return A `data.table` with the calculated expression of each sample, biological replicate and target gene. Contains the following fields:
#' -  `Sample`: Name of sample template.
#' -  `Biol.rep`: Biological replicate number.
#' -  `Target`: Name of gene of interest.
#' -  `Cq.tech.mean`: Arithmetic average of Cq between technical replicates for each gene of interest, sample and biological replicate.
#' -  `reference.gene.Cq.tech.mean`: Arithmetic average of Cq between technical replicates for each reference gene, sample and biological replicate.
#' -  `reference.gene.amplification.base`: Amplification base of each reference gene, as provided by standard curve calculations. If not provided, amplification base 2 will be assumed.
#' -  `reference.gene.Cq.weighed`: Weighed Cq (or Cq^{w}_{ref}) for each reference gene and biological replicate. Calculated as follows: Cq^{w}_{ref} = Cq_{ref} * log_{2}amplification.base_{ref}
#' -  `Ref.Cq.weighed.mean`: Arithmetic mean of weighed Cq between all reference genes for each sample and biological replicate.
#' -  `GOI.amplification.base`: Amplification base of each gene of interest, as provided by standard curve calculations. If not provided, amplification base 2 will be assumed.
#' -  `GOI.Cq.weighed`: Weighed Cq (or Cq^{w}^=_{GOI}) for each gene of interest and biological replicate. Calculated as follows: Cq^{w}_{GOI} = Cq_{GOI} * log_{2}amplification.base_{GOI}
#' -  `DCq.weighed`: Difference between `Ref.Cq.weighed.mean` and and `GOI.Cq.weighed`.
#' -  `control.DCq.weighed`: Average `DCq.weighed` of designated control sample for each gene of interest.
#' -  `log2.fold.change`: Difference between `DCq.weighed` and `control.DCq.weighed`. Also equal to log_2_ of fold-change.
#' -  `fold.change`: Fold-change of quantity in relation to control sample.
#'
#' @import data.table
#'
#' @export

qPCR_analysis_expression <- function(unkdata,refgene,efficiencies=NULL,control=NULL) {

  unkdata <- copy(unkdata)
  setDT(unkdata)

  if(is.null(control)) {
    control <- levels(unkdata$Sample)[1]
  }

  if(is.null(efficiencies)) {
    efficiencies <- data.table(Target=levels(unkdata$Target),amplification.base=NA)
  }

  for(i in 1:nrow(efficiencies)) {
    if(is.na(efficiencies[i,amplification.base])) {
      warning(paste("Primer efficiency for",
                    efficiencies[i,Target],
                    "is not provided, so 100% efficiency is assumed."))
    }
  }

  unkdata[,Cq.tech.sd := NULL]

  for(refname in refgene) {

    # Find the Cq values of each reference gene and put them in a new column
    unkdata[,paste0(refname,".Cq.tech.mean"):=
              Cq.tech.mean[Target==refname],
            by=c("Sample","Biol.rep")]

    # Erase the reference gene rows from the data frame
    unkdata <- droplevels(unkdata[!Target==refname,])

    # Enter the corresponding amplification base
    unkdata[,paste0(refname,".amplification.base"):=
              efficiencies[Target==refname,amplification.base]]

    unkdata[is.na(paste0(refname,"amplification.base")),
            paste0(refname,".amplification.base"):=2L]

    # Calculate weighed Cq for the corresponding reference gene
    unkdata[,paste0(refname,".Cq.weighed"):=
              log(get(paste0(..refname,".amplification.base")),base=2)*
              get(paste0(..refname,".Cq.tech.mean"))]

  }


  # Calculate mean Cq of all reference genes, if more than one. Otherwise, just copy the Cq of the one.
  unkdata[,Ref.Cq.weighed.mean:=
            mean(get(paste0(..refgene,".Cq.weighed"))),
          by=1:nrow(unkdata)]

  # Pick amplification base for each gene
  unkdata[efficiencies,
          GOI.amplification.base:=amplification.base,
          on="Target"]

  unkdata[is.na(GOI.amplification.base),GOI.amplification.base:=2L]

  # Calculate weighed Cq
  unkdata[,GOI.Cq.weighed:=
            log(GOI.amplification.base,base=2)*Cq.tech.mean]

  # Calculate DCq.weighed
  unkdata[,DCq.weighed:=
            Ref.Cq.weighed.mean-GOI.Cq.weighed]

  # Calculate mean of control DCq.weighed
  unkdata[,control.DCq.weighed:=
            mean(DCq.weighed[Sample==control]),
          by=Target]

  # Calculate log2.fold.change
  unkdata[,log2.fold.change:=
            DCq.weighed-control.DCq.weighed]

  # Calculate relative quantity
  unkdata[,fold.change:=
            2^log2.fold.change]

  return(unkdata)
}
