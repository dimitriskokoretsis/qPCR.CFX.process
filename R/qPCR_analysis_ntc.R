#' Real-time qPCR non-template control processing.
#'
#' @description
#' Parses primary qPCR data (Cq values) and summarizes results for non-template controls.
#' Compatible with Cq data exported from Bio-Rad CFX Connect real-time PCR machine.
#'
#' @param d `data.frame`, Cq value data exported from Bio-Rad CFX Connect real-time PCR machine.
#'
#' @return A `data.table` with primer targets and Cq values, each row being a non-template control reaction.
#'
#' @import data.table
#'
#' @export

qPCR_analysis_ntc <- function(d) {

  d <- copy(d)
  setDT(d)

  d <- droplevels(d[Content=="NTC"])

  d[,names(d)[!(names(d) %in% c("Target","Cq"))]:=
        NULL]

  return(d)
}
