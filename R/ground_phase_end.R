.ground_phase_end <- function(fluorescence,points=4) {
  # under construction
  if(points > length(fluorescence)) {
    return(NA)
  } else {
    d <- data.frame(x=1:points,y=fluorescence[1:points])
    model <- lm(y ~ x, data=d)
    stud.res.p.value <- model |>
      MASS::studres() |>
      pt(df=points-1-2)
    if(stud.res.p.value[points] > 0.95 &
       stud.res.p.value[points-1] > 0.95) {
      return(points-1)
    } else {
      return(.ground_phase_end(fluorescence=fluorescence,points=points+1))
    }
  }
}
