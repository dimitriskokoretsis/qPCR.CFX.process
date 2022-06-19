#' Real-time qPCR standard curve and primer efficiency calculation.
#'
#' @description
#' Parses primary qPCR data (Cq values) and calculates primer efficiencies based on standard curve serial dilutions.
#' Compatible with Cq data exported from Bio-Rad CFX Connect real-time PCR machine.
#'
#' @details
#' Standard curve slopes and resulting efficiencies are calculated by fitting the Cq values (y) against the log(starting quantity) (x)
#' on a linear model (function `lm(y~x)`).
#'
#' @param d `data.frame`, Cq value data exported from Bio-Rad CFX Connect real-time PCR machine.
#' @param graph Logical. If `TRUE`, also draws and returns the standard curves on a scatter plot with trend lines. Defaults to `FALSE`.
#'
#' @return A list with 3 elements:
#' -  `$data`: A `data.table` with the Cq values against log(Starting quantity) for each target gene.
#' -  `$efficiencies`: A `data.table` with the calculated efficiencies for each target gene.
#' -  `$graph`: The scatter plot with the drawn standard curves, if requested.
#' Points are technical means, error bars are technical standard deviations.
#'
#' @import data.table
#' @import ggplot2
#' @import ggthemes
#'
#' @export

qPCR_analysis_std_curve <- function(d,graph=FALSE) {

  d <- copy(d)
  setDT(d)

  d <- droplevels(d[Content=="Std"])

  d[,names(d)[!(names(d) %in% c("Target","Sample","Cq","Log.Starting.Quantity"))]:=
        NULL]

  d[,Cq.average:=
        mean(Cq),
      by=c("Target","Log.Starting.Quantity")]

  d[,Cq.st.dev:=
        sd(Cq),
      by=c("Target","Log.Starting.Quantity")]

  d[,Cq:=
        NULL]

  d <- unique(d,by=c("Target","Log.Starting.Quantity"))

  #------------------------------------------------ Calculate efficiencies and slopes ---------------------------------------------------

  efficiencies <- copy(d)

  efficiencies[,slope:=
                 lm(Cq.average ~ Log.Starting.Quantity)$coefficients[[2]],
               by=Target]

  efficiencies[,efficiency:=
                 10^(-1/slope)-1,
               by=Target]

  efficiencies <- unique(efficiencies,by="Target")

  efficiencies[,names(efficiencies)[!(names(efficiencies) %in% c("Target","slope","efficiency"))]:=
                 NULL]

  efficiencies[,amplification.base:=
                 efficiency+1]

  #-------------------------------------------------------- Draw standard curves --------------------------------------------

  if(graph==TRUE) {
    # Plot standard curves
    plot <- ggplot(data=d,mapping=aes(x=Log.Starting.Quantity,y=Cq.average,color=Target)) +
      theme_classic() +
      xlab(paste0("Log starting quantity (",dat[1,Sample],")")) +
      ylab("Threshold cycle") +
      geom_smooth(se=FALSE,method="lm",size=1) +
      geom_point(size=1.5) +
      geom_errorbar(mapping=aes(ymin=Cq.average-Cq.st.dev,ymax=Cq.average+Cq.st.dev),
                    colour="black",width=0) +
      scale_color_discrete("Target")
  } else {
    plot <- NULL
  }

  return(list(data=d,efficiencies=efficiencies,graph=plot))
}
