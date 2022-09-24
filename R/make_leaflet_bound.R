#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_bound <- function(input,
                               ...) {
  bbox <- input@bbox

  bound <- base::list()

  bound$lng1 <- bbox[1, 1]
  bound$lat1 <- bbox[2, 1]
  bound$lng2 <- bbox[1, 2]
  bound$lat2 <- bbox[2, 2]

  bound
}

# make_leaflet_bound(input)
# bound <- make_leaflet_bound(input)
