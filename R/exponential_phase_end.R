.exponential_phase_end <- function(fluorescence,exp.start,points=4) {
  # under construction
  if((points + exp.start > length(fluorescence)) |
     (is.na(exp.start))) {
    return(NA)
  } else {
    d <- data.frame(x=exp.start:(exp.start+points-1),y=log(fluorescence[exp.start:(exp.start+points-1)]))
    model <- lm(y ~ x, data=d)
    stud.res.p.value <- model |>
      MASS::studres() |>
      pt(df=points-1-2)
    if(stud.res.p.value[points] < 0.05) {
      return(exp.start + points)
    } else {
      return(.exponential_phase_end(fluorescence=fluorescence,exp.start=exp.start,points=points+1))
    }
  }
}
