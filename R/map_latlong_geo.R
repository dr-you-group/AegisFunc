#' Title
#'
#' @param ...
#' @param latlong
#' @param geo
#'
#' @return
#' @export
#'
#' @examples
map_latlong_geo <- function(latlong, geo,
                            ...) {
  latlong <- latlong
  geo <- geo

  sp::coordinates(latlong) <- ~ longitude + latitude
  sp::proj4string(latlong) <- sp::proj4string(geo)

  geo_map <- sp::over(latlong, geo)
  # geo_map$location_id <- base::seq(1:base::nrow(geo_map))
  geo_map <- base::cbind(geo_map, latlong)
  geo_map <- base::merge(geo, geo_map, all.x = T)

  for (i in 1:base::max(base::unique(geo_map$oid))) {
    geo_map[(geo_map$oid == i), c("latitude", "longitude")] <- geo_map[(geo_map$oid == i), c("latitude", "longitude")][1, c("latitude", "longitude")]
  }

  geo_map <- geo_map[base::order(geo_map$oid), ]

  geo_map
}
