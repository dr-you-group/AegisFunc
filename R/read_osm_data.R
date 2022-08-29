read_osm_data <- function(input,
                          ...) {
  name <- input$geo$name
  country <- input$geo$country
  level <- input$geo$level

  place <- "Korea"
  osmid = "307756"
  osmtype = "relation"

  bbox <- osmdata::getbb(place)
  # q <- osmdata::opq_osm_id(osmid, osmtype)
  # q <- osmdata::opq_string(q)
  q <- osmdata::opq(bbox)
  # q <- osmdata::add_osm_feature(
  #   q,
  #   key = "boundary",
  #   value = c("administrative")
  # )
  # q <- osmdata::add_osm_features(
  #   q,
  #   features = c(
  #     "\"boundary\"=\"administrative\"",
  #     "\"admin_level\"=\"2\""
  #   )
  # )
  q <- osmdata::add_osm_features(
    q,
    features = c(
      "\"boundary\"=\"administrative\"",
      "\"admin_level\"=\"6\"",
      "\"place\"=\"city\"",
      "\"place\"=\"district\""
    )
  )
  # q <- osmdata::add_osm_features(
  #   q,
  #   features = c(
  #     "\"place\"=\"country\""
  #   )
  # )

  geo <- osmdata::osmdata_sp(q)
  base::names(geo)
  base::length(geo)
  # geo <- geo$osm_points
  # geo <- geo$osm_lines
  # geo <- geo$osm_polygons
  # geo <- geo$osm_multilines
  # geo <- geo$osm_multipolygons

  # kor_points <- geo$osm_points@data[,c("name", "admin_level")]
  # kor_lines <- geo$osm_lines@data[,c("name", "admin_level")]
  # kor_polygons <- geo$osm_polygons@data[,c("name", "admin_level")]
  # kor_multilines <- geo$osm_multilines@data[,c("name", "admin_level")]
  # kor_multipolygons <- geo$osm_multipolygons@data[,c("name", "admin_level")]
  # utils::write.csv(kor_points, "osm_points.csv")
  # utils::write.csv(kor_lines, "osm_lines.csv")
  # utils::write.csv(kor_polygons, "osm_polygons.csv")
  # utils::write.csv(kor_multilines, "osm_multilines.csv")
  # utils::write.csv(kor_multipolygons, "osm_multipolygons.csv")

  # ggplot2::ggplot() + ggplot2::geom_polygon(data=geo$osm_polygons@data)
  # ggplot2::ggplot() + ggplot2::geom_sf(data=geo$osm_points@data)
  # ggplot2::ggplot() + ggplot2::geom_sf(data=geo$osm_polygons)

  geo
}

# read_osm_data(input)
# geo <- read_osm_data(input)
