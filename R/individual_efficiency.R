.individual_efficiency <- function(fluorescence) {
  # under construction
  exp.start <- .ground_phase_end(fluorescence)
  exp.end <- .exponential_phase_end(fluorescence,exp.start=exp.start) - 1
  if(is.na(exp.start)) {
    return(NA)
  } else {
    if(is.na(exp.end)) {
      exp.end <- length(fluorescence)
    }
    d <- data.frame(x=exp.start:exp.end,
                    y=log(fluorescence[exp.start:exp.end]))
    model <- lm(y ~ x, data=d)
    efficiency <- model$coefficients[names(model$coefficients)=="x"] |>
      exp() - 1
    return(efficiency)
  }
}
