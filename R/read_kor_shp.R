#' Title
#'
#' @param ...
#' @param country
#' @param level
#'
#' @return
#' @export
#'
#' @examples
read_kor_shp <- function(country, level,
                         ...) {
  country <- country
  level <- base::as.numeric(level)

  shp_file_name <- base::paste0(country, "_", level)

  shp_file_path <- base::system.file("extdata", "geo", "shp", shp_file_name, base::paste0(shp_file_name, ".shp"), package = "AegisFunc")
  # shp_file_path <- base::file.path(base::getwd(), "inst", "extdata", "geo", "shp", shp_file_name, base::paste0(shp_file_name, ".shp"))

  geo <- raster::shapefile(shp_file_path, encoding = "EUC-KR")

  to_crs <- sp::CRS("+proj=longlat +datum=WGS84")

  geo <- sp::spTransform(geo, to_crs)

  geo
}
