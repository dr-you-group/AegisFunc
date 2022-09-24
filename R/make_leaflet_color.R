#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_color <- function(input,
                               ...) {
  palette <- input$palette
  domain <- input$domain
  n <- input$n

  color <- leaflet::colorQuantile(
    palette = palette,
    domain = domain,
    n = n
  )

  color
}

# make_leaflet_color(input)
# color <- make_leaflet_color(input)
