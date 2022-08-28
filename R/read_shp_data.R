read_shp_data <- function(input,
                          ...) {
  country <- input$gadm$country
  level <- input$gadm$level

  shp_file_name <- base::paste0(country, "_", level)

  # shp_file_path <- base::system.file("extdata", "gis", "shp", shp_file_name, base::paste0("shp_file_name", ".shp"), package = "AegisFunc")
  shp_file_path <- base::file.path(base::getwd(), "inst", "extdata", "gis", "shp", shp_file_name, base::paste0(shp_file_name, ".shp"))

  shp <- raster::shapefile(shp_file_path, encoding = "EUC-KR")

  shp <- convert_crs(shp)

  pattern <- "KOR_NM"
  name_idx <- grep(pattern, names(shp))

  if (length(name_idx) > 1) {
    shp$name <- apply(shp@data[, name_idx], 1, paste, collapse = " ")
  } else {
    shp$name <- shp@data[, name_idx]
  }

  shp
}

# read_shp_data(input)
# shp <- read_shp_data(input)

convert_crs <- function(shp){
  to_crs <- sp::CRS("+proj=longlat +datum=WGS84")

  shp <- sp::spTransform(shp, to_crs)

  shp
}
