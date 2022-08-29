get_geo_data <- function(input,
                         ...) {
  name <- input$geo$name
  country <- input$geo$country
  level <- input$geo$level

  switch(name,
    "OSM" = {
      geo <- read_osm_data(input)
    },
    "GADM" = {
      geo <- read_gadm_data(input)
      pattern <- "^NAME_([1-9])"
    },
    "KOR" = {
      if (country == "KOR") {
        geo <- read_kor_shp(input)
        pattern <- "KOR_NM"
      }
    }
  )

  geo$oid <- base::seq(1:length(geo))

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

# get_geo_data(input)
# geo <- get_geo_data(input)
