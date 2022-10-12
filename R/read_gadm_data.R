#' Title
#'
#' @param ...
#' @param name
#' @param country
#' @param level
#'
#' @return
#' @export
#'
#' @examples
read_gadm_data <- function(name, country, level,
                           ...) {
  name <- name
  country <- country
  level <- base::as.numeric(level)
  download <- TRUE
  path <- base::getwd()
  version <- 3.6
  type <- "sp"

  geo <- raster::getData(
    name = name,
    download = download,
    path = path,
    country = country,
    level = level,
    version = version,
    type = type
  )

  geo
}
