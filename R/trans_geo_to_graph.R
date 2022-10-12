#' Title
#'
#' @param ...
#' @param geo
#'
#' @return
#' @export
#'
#' @examples
trans_geo_to_graph <- function(geo,
                               ...) {
  path <- base::getwd()
  geo <- geo
  graph_file_path <- base::file.path(path, "geo.graph")

  # table(rgeos::gIsValid(geo, byid=TRUE))
  # nb <- spdep::poly2nb(geo)
  geo <- rgeos::gBuffer(geo, width = 0, byid = TRUE)
  # table(rgeos::gIsValid(geo, byid=TRUE))
  nb <- spdep::poly2nb(geo)

  spdep::nb2INLA(graph_file_path, nb)

  graph_file_path
}
