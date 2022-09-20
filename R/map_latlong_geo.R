map_latlong_geo <- function(input,
                            ...) {
  latlong <- input$latlong
  geo <- input$geo

  sp::coordinates(latlong) <- ~ longitude + latitude
  sp::proj4string(latlong) <- sp::proj4string(geo)

  geo_map <- sp::over(latlong, geo)
  # geo_map$location_id <- base::seq(1:base::nrow(geo_map))
  geo_map <- base::cbind(geo_map, latlong)

  geo_map
}

# map_latlong_geo(input)
# geo_map <- map_latlong_geo(input)
