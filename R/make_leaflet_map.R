make_leaflet_map <- function(input,
                             ...) {
  data <- input$data
  color <- input$color
  popup <- input$popup
  bound <- input$bound
  # view <- input$view

  map <- leaflet::leaflet()
  map <- leaflet::addProviderTiles(map, "CartoDB.Positron")
  map <- leaflet::fitBounds(map, bound$lng1, bound$lat1, bound$lng2, bound$lat2)
  # map <- leaflet::setView(map, view$lng, view$lat, zoom = view$zoom)
  # map <- leaflet::setView(map, -98.35, 39.7, zoom = 4) # USA
  # map <- leaflet::setView(map, 128.01, 35.86, zoom = 7) # South Korea
  map <- leaflet::addPolygons(
    map,
    data = data,
    fillColor = ~ color(indicator),
    fillOpacity = 0.4,
    weight = 2,
    color = "white",
    popup = popup
  )

  map
}

# make_leaflet_map(input)
# map <- make_leaflet_map(input)
