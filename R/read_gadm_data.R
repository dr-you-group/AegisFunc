read_gadm_data <- function(input,
                           ...) {
  name <- "GADM"
  download <- TRUE
  path <- base::getwd()
  country <- input$gadm$country
  level <- input$gadm$level

  gadm <- raster::getData(
    name = name,
    download = download,
    path = path,
    country = country,
    level = level
  )

  gadm
}

# read_gadm_data(input)
# gadm <- read_gadm_data(input)
