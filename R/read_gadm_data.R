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
  name_idx <- base::grep(pattern, base::names(gadm))

  if (!base::length(base::grep("name", base::names(gadm))) > 0 & base::length(name_idx) > 0) {
    gadm$name <- base::apply(gadm@data[, name_idx], 1, base::paste, collapse = " ")
  }

  gadm
}

# read_gadm_data(input)
# gadm <- read_gadm_data(input)
