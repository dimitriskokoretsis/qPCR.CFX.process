#' @import data.table
#'
#' @export

qPCR_analysis_expression <- function(unkdata,refgene,efficiencies=NULL,control=levels(unkdata$Sample)[1]) {
  #  FUNCTION 4: Calculate expression and store in new dataframe

  # Calculate expression according to the Pfaffl method and using the Ganger et al. 2017 variation.
  # Takes into account different primer pair efficiencies and potentially multiple reference genes

  # Input:
  # unkdata: the data frame resulting from the qPCR.unk.rxn.analysis function.
  #   Contains the technical means and standard deviations of Ct values of all biological replicates and samples and for each gene.
  # refgene: a character vector containing the names of the reference genes. Can have one or many elements.
  # efficiencies: the data frame resulting from the standard.curve.analysis function ($efficiencies). Contains the primer efficiency data.
  #   Will use efficiency of 100% for all primer pairs by default.
  # control: an one-element character vector with the name of the control sample

  # Returned data:
  # Data frame containing the expression

  unkdata <- copy(unkdata)
  setDT(unkdata)

  if(is.null(efficiencies)) {
    efficiencies<-data.table(target=levels(unkdata$Target),efficiency=1L)
    efficiencies[,amplification.base:=
                   efficiency+1]
  }

  unkdata[,Cq.tech.sd:=
            NULL]

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

  # Calculate DDCq.weighed
  unkdata[,log2.fold.change:=
            DCq.weighed-control.DCq.weighed]

  # Calculate relative quantity
  unkdata[,fold.change:=
            2^log2.fold.change]

  return(unkdata)
}
