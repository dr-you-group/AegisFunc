trans_geo_to_graph <- function(input,
                                ...) {
  path <- base::getwd()
  # name <- input$geo$name
  # country <- input$geo$country
  # level <- base::as.numeric(input$geo$level)
  # graph_file_path <- base::file.path(path, base::paste0("geo", "_", name, "_", country, "_", level, ".graph"))
  graph_file_path <- base::file.path(path, "geo.graph")

  # geo <- get_geo_data(input)

  # table(rgeos::gIsValid(geo, byid=TRUE))
  # nb <- spdep::poly2nb(geo)
  geo <- rgeos::gBuffer(geo, width=0, byid=TRUE)
  # table(rgeos::gIsValid(geo, byid=TRUE))
  nb <- spdep::poly2nb(geo)

  spdep::nb2INLA(graph_file_path, nb)

  graph_file_path
}

# trans_geo_to_graph(input)
# graph_file_path <- trans_geo_to_graph(input)
