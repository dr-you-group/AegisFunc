trans_geo_to_graph <- function(input,
                                ...) {
  path <- base::getwd()
  country <- input$geo$country
  level <- input$geo$level
  graph_file_path <- base::file.path(path, base::paste0("geo", "_", country, "_", level, ".graph"))

  geo <- read_geo_data(input)
  nb <- spdep::poly2nb(geo)
  spdep::nb2INLA(graph_file_path, nb)

  graph_file_path
}

# trans_geo_to_graph(input)
# graph_file_path <- trans_geo_to_graph(input)
