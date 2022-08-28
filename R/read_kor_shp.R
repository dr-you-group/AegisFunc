read_kor_shp <- function(input,
                         ...) {
  country <- input$geo$country
  level <- input$geo$level

  shp_file_name <- base::paste0(country, "_", level)

  # shp_file_path <- base::system.file("extdata", "geo", "shp", shp_file_name, base::paste0("shp_file_name", ".shp"), package = "AegisFunc")
  shp_file_path <- base::file.path(base::getwd(), "inst", "extdata", "geo", "shp", shp_file_name, base::paste0(shp_file_name, ".shp"))

  geo <- raster::shapefile(shp_file_path, encoding = "EUC-KR")

  to_crs <- sp::CRS("+proj=longlat +datum=WGS84")

  geo <- sp::spTransform(geo, to_crs)


  pattern <- "KOR_NM"
  name_idx <- base::grep(pattern, names(geo))

  if (base::length(name_idx) > 1) {
    geo$name <- base::apply(geo@data[, name_idx], 1, base::paste, collapse = " ")
  } else {
    geo$name <- geo@data[, name_idx]
  }

  geo
}

# read_kor_shp(input)
# geo <- read_kor_shp(input)
