lagrange_multiplier_for_projection_onto_l1_ball <- function(x, r) {
  # assumes that all x are non-negative
  if(sum(x) <= r) return (0)
  y <- sx <- sort(x, decreasing = TRUE)
  y <- (cumsum(y) - r) / seq_along(y)
  y[y < 0] <- 0
  c <- max(which(sx > y))
  y[c]
}

l1_projection <- function(x, r) {
  ss <- sign(x)
  x <- abs(x)
  proj_x <- x - lagrange_multiplier_for_projection_onto_l1_ball(x, r)
  proj_x[proj_x < 0] <- 0
  proj_x*ss
}

smooth_ramp <- function(x) {
  nice_curve <- function(x) 25*(x^3) - 62.5*(x^4)
  ifelse(
    x < -0.1, 0, 
  ifelse(
    x > 0.1, x,
  ifelse(x < 0, nice_curve(0.1 + x), 
    x + nice_curve(0.1 - x)
  )))
}

smooth_threshold_fun <- function(x, d) {
  smooth_ramp(x - d) - smooth_ramp(-d - x)
}
