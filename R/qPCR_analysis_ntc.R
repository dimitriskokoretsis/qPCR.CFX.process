#' @import data.table
#'
#' @export

qPCR_analysis_ntc <- function(d) {
  # FUNCTION 1: Check non-template controls

  # Input: the qPCR raw data
  # Returns a data frame with the Ct values of each non-template control reaction

  d <- copy(d)
  setDT(d)

  d <- droplevels(d[Content=="NTC"])

  d[,names(d)[!(names(d) %in% c("Target","Cq"))]:=
        NULL]

  return(d)
}
