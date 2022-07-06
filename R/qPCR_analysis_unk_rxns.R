#' Real-time qPCR unknown sample reaction processing.
#'
#' @description
#' Parses primary qPCR data (Cq values) and calculates technical means for each sample, biological replicate and gene.
#' Compatible with Cq data exported from Bio-Rad CFX Connect real-time PCR machine.
#'
#' @param d `data.frame`, Cq value data exported from Bio-Rad CFX Connect real-time PCR machine.
#'
#' @return A `data.table` with Cq values for each sample, biological replicate and gene. Contains the following fields:
#' -  `Sample`: Name of sample template.
#' -  `Biol.rep`: Biological replicate number.
#' -  `Target`: Name of target gene.
#' -  `Cq.tech.mean`: Arithmetic mean between technical replicates.
#' -  `Cq.tech.sd`: Standard deviation between technical replicates.
#'
#' @import data.table
#'
#' @export

qPCR_analysis_unk_rxns <- function(d) {

  d <- copy(d)
  setDT(d)

  d <- droplevels(d[Content=="Unkn"])

  d[,names(d)[!(names(d) %in% c("Target","Sample","Cq"))]:=
        NULL]

  d[,Biol.rep:=
        tstrsplit(Sample,split=" (?=[^ ]+$)",perl=TRUE,keep=2L)]

  d[,Sample:=
        tstrsplit(Sample,split=" (?=[^ ]+$)",perl=TRUE,keep=1L)]

  setcolorder(d,neworder=c("Sample","Biol.rep","Target","Cq"))


  # Calculation of means and SDs. Done in data.table because it's so much easier

  d[,Cq.tech.mean:=
        mean(Cq),
      by=c("Target","Sample","Biol.rep")]

  d[,Cq.tech.sd:=
        sd(Cq),
      by=c("Target","Sample","Biol.rep")]

  d <- unique(d,by=c("Target","Sample","Biol.rep"))

  d[,Cq:=
        NULL][]

  setorder(d,Target,Sample,Biol.rep)

  return(d)
}
