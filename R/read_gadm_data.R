read_gadm_data <- function(input,
                           ...) {
  name <- "GADM"
  download <- TRUE
  path <- base::getwd()
  country <- input$gadm$country
  level <- input$gadm$level
  version <- 3.6
  type <- "sp"

  if (country == "KOR") {
    gadm <- read_shp_data(input)

  } else {
    gadm <- raster::getData(
      name = name,
      download = download,
      path = path,
      country = country,
      level = level,
      version = version,
      type = type
    )
  }

  gadm$oid <- base::seq(1:length(gadm))

  gadm
}

# read_gadm_data(input)
# gadm <- read_gadm_data(input)
