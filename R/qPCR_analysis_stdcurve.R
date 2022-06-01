#' @import data.table
#' @import ggplot2
#' @import ggthemes
#'
#' @export

qPCR_analysis_std_curve <- function(d,graph=FALSE) {
  # FUNCTION 2: Standard curve data

  # Input: the qPCR raw data

  # Returns a list containing 3 items:
  # $dat: Data frame with the technical means and standard deviations for each target gene and each dilution
  # $efficiencies: Data frame with the calculated curve slopes and primer pair efficiencies for each target gene
  # Slopes and resulting efficiencies are calculated with the formula lm(y~x), which makes a linear model of y based on x
  # $graph: A scatter plot of Ct values VS log(starting quantity) with the standard curve for each target gene.
  # Dots are technical means, error bars are technical standard deviations
  # Trend lines are drawn according to linear regressions (Ct values ∼ log(starting quantity)), using the plotting function scatter.trend.plot

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
