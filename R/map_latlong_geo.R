map_latlong_geo <- function(input,
                            ...) {
  latlong <- input$latlong
  geo <- input$geo

  sp::coordinates(latlong) <- ~ longitude + latitude
  sp::proj4string(latlong) <- sp::proj4string(geo)

  geo <- sp::over(latlong, geo)
  geo$location_id <- base::seq(1:nrow(geo))

  geo <- sp::merge(latlong, geo, by="location_id")

  geo
}

# map_latlong_geo(input)
# geo <- map_latlong_geo(input)