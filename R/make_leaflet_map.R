#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_map <- function(input,
                             ...) {
  data <- input$data
  color <- input$color
  popup <- input$popup
  bound <- input$bound

  map <- leaflet::leaflet()
  map <- leaflet::addProviderTiles(map, "CartoDB.Positron")
  map <- leaflet::fitBounds(map, bound$lng1, bound$lat1, bound$lng2, bound$lat2)
  map <- leaflet::addPolygons(
    map,
    data = data,
    fillColor = ~ color(indicator),
    fillOpacity = 0.8,
    weight = 1,
    color = "white",
    popup = popup
  )

  map
}

# make_leaflet_map(input)
# map <- make_leaflet_map(input)
