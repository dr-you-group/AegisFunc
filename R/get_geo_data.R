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
get_geo_data <- function(name, country, level,
                         ...) {
  name <- name
  country <- country
  level <- base::as.numeric(level)

  switch(name,
    "GADM" = {
      geo <- AegisFunc::read_gadm_data(name, country, level)
      pattern <- "^NAME_([1-9])"
    },
    "KOR" = {
      if (country == "KOR") {
        geo <- AegisFunc::read_kor_shp(country, level)
        pattern <- "KOR_NM"
      }
    }
  )

  latlong <- base::data.frame(sp::coordinates(geo))
  base::colnames(latlong) <- base::c("long", "lat")

  geo <- base::cbind(geo, latlong)

  geo$otype <- name
  geo$oid <- base::seq(1:base::nrow(geo))

  name_idx <- base::grep(pattern, base::names(geo))
  name_len <- base::length(name_idx)

  if (name_len > 1) {
    geo$oname <- base::apply(geo@data[, name_idx], 1, base::paste, collapse = " ")
  } else if (name_len == 1) {
    geo$oname <- geo@data[, name_idx]
  }

  base::colnames(geo@data) <- base::tolower(base::colnames(geo@data))

  geo
}
