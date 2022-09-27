#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
get_leaflet_map <- function(input,
                            ...) {
  color <- AegisFunc::make_leaflet_color(input)
  popup <- AegisFunc::make_leaflet_popup(input)
  bound <- AegisFunc::make_leaflet_bound(input)

  input$color <- color
  input$popup <- popup
  input$bound <- bound

  map <- AegisFunc::make_leaflet_map(input)

  map
}

# get_leaflet_map(input)
# map <- get_leaflet_map(input)
