#' Title
#'
#' @param ...
#' @param data
#' @param color
#' @param popup
#' @param bound
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_map <- function(data, color, popup, bound,
                             ...) {
  data <- data
  color <- color
  popup <- popup
  bound <- bound

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
