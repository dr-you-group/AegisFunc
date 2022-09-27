#' Title
#'
#' @param ...
#' @param input
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_color <- function(input,
                               ...) {
  type <- input$type

  palette <- "Greens"   # colorNumeric, colorBin, colorQuantile, colorFactor
  domain <- NULL        # colorNumeric, colorBin, colorQuantile, colorFactor
  bins <- 7             # colorBin
  pretty <- TRUE        # colorBin
  n <- 4                # colorQuantile
  levels <- NULL        # colorFactor
  ordered <- FALSE      # colorFactor
  na.color <- "#808080" # colorNumeric, colorBin, colorQuantile, colorFactor
  alpha <- FALSE        # colorNumeric, colorBin, colorQuantile, colorFactor
  reverse <- FALSE      # colorNumeric, colorBin, colorQuantile, colorFactor
  right <- FALSE        # colorBin, colorQuantile

  color <- leaflet::colorBin(
    palette = palette,
    domain = domain,
    bins = bins
  )

  if (type == "map") {
    color <- leaflet::colorQuantile(
      palette = palette,
      domain = domain,
      n = 9
    )
  } else if (type == "cluster") {
    color <- leaflet::colorQuantile(
      palette = palette,
      domain = domain,
      n = 1
    )
  }

  color
}

# make_leaflet_color(input)
# color <- make_leaflet_color(input)
