read_geo_data <- function(input,
                          ...) {
  name <- "GADM"
  download <- TRUE
  path <- base::getwd()
  country <- input$geo$country
  level <- input$geo$level
  version <- 3.6
  type <- "sp"

  if (country == "KOR") {
    geo <- read_kor_shp(input)
  } else {
    geo <- raster::getData(
      name = name,
      download = download,
      path = path,
      country = country,
      level = level,
      version = version,
      type = type
    )
  }

  geo$oid <- base::seq(1:length(geo))

  pattern <- "^NAME_([1-9])"
  name_idx <- base::grep(pattern, base::names(geo))

  if (!base::length(base::grep("name", base::names(geo))) > 0 & base::length(name_idx) > 0) {
    if (base::length(name_idx) > 1) {
      geo$name <- base::apply(geo@data[, name_idx], 1, base::paste, collapse = " ")
    } else {
      geo$name <- geo@data[, name_idx]
    }
  }

  geo
}

# read_geo_data(input)
# geo <- read_geo_data(input)
