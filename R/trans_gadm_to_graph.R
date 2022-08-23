trans_gadm_to_graph <- function(input,
                                ...) {
  path <- base::getwd()
  country <- input$gadm$country
  level <- input$gadm$level
  graph_file_path <- base::file.path(path, base::paste0("gadm", "_", country, "_", level, ".graph"))

  gadm <- read_gadm_data(input)
  nb <- spdep::poly2nb(gadm)
  spdep::nb2INLA(graph_file_path, nb)

  graph_file_path
}

# trans_gadm_to_graph(input)
# graph_file_path <- trans_gadm_to_graph(input)
