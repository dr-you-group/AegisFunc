#' Title
#'
#' @param type
#' @param param
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_color <- function(type, param,
                               ...) {
  type <- type
  param <- param

  palette <- "Reds" # colorNumeric, colorBin, colorQuantile, colorFactor
  domain <- NULL # colorNumeric, colorBin, colorQuantile, colorFactor
  bins <- 7 # colorBin
  pretty <- TRUE # colorBin
  n <- 4 # colorQuantile
  levels <- NULL # colorFactor
  ordered <- FALSE # colorFactor
  na.color <- "#FFFFFF" # colorNumeric, colorBin, colorQuantile, colorFactor
  alpha <- FALSE # colorNumeric, colorBin, colorQuantile, colorFactor
  reverse <- FALSE # colorNumeric, colorBin, colorQuantile, colorFactor
  right <- FALSE # colorBin, colorQuantile

  palette <- param$palette
  domain <- param$domain
  bins <- param$bins
  pretty <- param$pretty
  n <- param$n
  levels <- param$levels
  ordered <- param$ordered
  na.color <- param$na.color
  alpha <- param$alpha
  reverse <- param$reverse
  right <- param$right

  color <- leaflet::colorQuantile(
    palette = palette,
    domain = domain,
    n = n,
    na.color = na.color,
    alpha = alpha,
    reverse = reverse,
    right = right
  )

  if (type == "colorNumeric") {
    color <- leaflet::colorNumeric(
      palette = palette,
      domain = domain,
      na.color = na.color,
      alpha = alpha,
      reverse = reverse
    )
  } else if (type == "colorBin") {
    color <- leaflet::colorBin(
      palette = palette,
      domain = domain,
      bins = bins,
      pretty = pretty,
      na.color = na.color,
      alpha = alpha,
      reverse = reverse,
      right = right
    )
  } else if (type == "colorQuantile") {
    color <- leaflet::colorQuantile(
      palette = palette,
      domain = domain,
      n = n,
      na.color = na.color,
      alpha = alpha,
      reverse = reverse,
      right = right
    )
  } else if (type == "colorFactor") {
    color <- leaflet::colorFactor(
      palette = palette,
      domain = domain,
      levels = levels,
      ordered = ordered,
      na.color = na.color,
      alpha = alpha,
      reverse = reverse
    )
  }

  color
}
