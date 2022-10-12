#' Title
#'
#' @param ...
#' @param data
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_bound <- function(data,
                               ...) {
  bbox <- data@bbox

  bound <- base::list()

  bound$lng1 <- bbox[1, 1]
  bound$lat1 <- bbox[2, 1]
  bound$lng2 <- bbox[1, 2]
  bound$lat2 <- bbox[2, 2]

  bound
}
