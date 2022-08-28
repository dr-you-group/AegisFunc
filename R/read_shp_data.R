read_shp_data <- function(input,
                          ...) {
  country <- input$gadm$country
  level <- input$gadm$level

  shp_file_name <- base::paste0(country, "_", level)

  # shp_file_path <- base::system.file("extdata", "gis", "shp", shp_file_name, base::paste0("shp_file_name", ".shp"), package = "AegisFunc")
  shp_file_path <- base::file.path(base::getwd(), "inst", "extdata", "gis", "shp", shp_file_name, base::paste0(shp_file_name, ".shp"))

  shp <- raster::shapefile(shp_file_path, encoding = "EUC-KR")

  shp
}

# read_shp_data(input)
# shp <- read_shp_data(input)
