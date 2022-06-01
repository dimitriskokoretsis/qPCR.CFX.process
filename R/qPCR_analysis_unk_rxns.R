#' @import data.table
#'
#' @export

qPCR_analysis_unk_rxns <- function(d) {
  # FUNCTION 3: Unknown sample reactions

  # Input: the qPCR raw data
  # Returns a data frame with the technical means and standard deviations of each sample, biological replicate and target gene

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
