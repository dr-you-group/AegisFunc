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

  pattern <- "^NAME([^0][1-9])"
  name_idx <- grep(pattern, names(gadm))

  if (!length(grep("name", names(gadm))) > 0 & length(name_idx) > 0) {
    gadm$name <- apply(gadm@data[, name_idx], 1, paste, collapse = " ")
  }

  gadm
}

# read_gadm_data(input)
# gadm <- read_gadm_data(input)
