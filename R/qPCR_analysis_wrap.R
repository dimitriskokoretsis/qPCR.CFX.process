#' Real-time qPCR result processing.
#'
#' @description Performs the whole processing of real-time qPCR data (Cq values),
#' including non-template control summary, standard curve analysis and expression analysis.
#' Compatible with Cq data exported from Bio-Rad CFX Connect real-time PCR machine.
#'
#' @param d `data.frame`, Cq value data exported from Bio-Rad CFX Connect real-time PCR machine.
#' @param refgene Character vector with the name(s) of the reference gene(s).
#' @param control Character. The name of the control sample, against which all other samples will be compared.
#' Defaults to the 1st sample alphabetically.
#' @param std.curve Logical. Determines whether or not to calculate efficiencies from standard curves or not.
#' If `FALSE`, standard curve reactions will be ignored and efficiencies of 100% will be assumed. Defaults to `TRUE`.
#' @param std.curve.plot Logical. Determines whether or not to plot standard curve data in a scatter plot with trend lines.
#' Defaults to `TRUE`.
#'
#' @return A list of 4 elements:
#' -  `$NTC`: Results from `qPCR_analysis_ntc` function.
#' -  `$std.curve`: Results from `qPCR_analysis_std_curve` function.
#' -  `$unk.rxn`: Results from `qPCR_analysis_unk_rxns` function.
#' -  `$expression`: Results from `qPCR_analysis_expression` function.
#'
#' @export

qPCR_analysis_wrap <- function(d,refgene,control=NULL,std.curve=TRUE,std.curve.plot=TRUE){

  NTC.results <- d |> qPCR_analysis_ntc()
  unk.rxn.results <- d |> qPCR_analysis_unk_rxns()

  #If there are standard curve reactions, make calculations from them. Otherwise, assume 100% efficiency for all primer pairs
  if(std.curve==TRUE) {
    std.curve.results <- d |> qPCR_analysis_std_curve(plot=std.curve.plot)
    expression.results <- unk.rxn.results |>
      qPCR_analysis_expression(refgene=refgene,
                               efficiencies=std.curve.results$efficiencies,
                               control=control)
  } else {
    std.curve.results <- NULL
    expression.results <- unk.rxn.results |>
      qPCR_analysis_expression(refgene=refgene,
                               efficiencies=NULL,
                               control=control)
  }

  return(list(NTC=NTC.results,
              std.curve=std.curve.results,
              unk.rxn=unk.rxn.results,
              expression=expression.results))
}
