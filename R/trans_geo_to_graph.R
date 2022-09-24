#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
trans_geo_to_graph <- function(input,
                               ...) {
  path <- base::getwd()
  geo <- input$geo
  graph_file_path <- base::file.path(path, "geo.graph")

  # table(rgeos::gIsValid(geo, byid=TRUE))
  # nb <- spdep::poly2nb(geo)
  geo <- rgeos::gBuffer(geo, width = 0, byid = TRUE)
  # table(rgeos::gIsValid(geo, byid=TRUE))
  nb <- spdep::poly2nb(geo)

  spdep::nb2INLA(graph_file_path, nb)

  graph_file_path
}

# trans_geo_to_graph(input)
# graph_file_path <- trans_geo_to_graph(input)
