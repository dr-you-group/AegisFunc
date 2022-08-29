read_gadm_data <- function(input,
                           ...) {
  name <- input$geo$name
  country <- input$geo$country
  level <- input$geo$level
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

# read_gadm_data(input)
# geo <- read_gadm_data(input)
