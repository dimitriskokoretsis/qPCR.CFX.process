#' @export

qPCR_analysis_wrap <- function(d,refgene,control,std.curve=TRUE){
  # Wraps all functions for qPCR data analysis

  NTC.results <- d |> qPCR_analysis_ntc()
  unk.rxn.results <- d |> qPCR_analysis_unk_rxns()

  #If there are standard curve reactions, make calculations from them. Otherwise, consider 100% efficiency for all primer pairs
  if(std.curve==TRUE) {
    std.curve.results <- d |> qPCR_analysis_std_curve()
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
