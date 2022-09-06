get_geo_data <- function(input,
                         ...) {
  name <- input$geo$name
  country <- input$geo$country
  level <- base::as.numeric(input$geo$level)

  switch(name,
    # "OSM" = {
    #   geo <- read_osm_data(input)
    #   pattern <- "^name$"
    # },
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

  geo$otype <- name
  geo$oid <- base::seq(1:base::nrow(geo))

  name_idx <- base::grep(pattern, base::names(geo))
  name_len <- base::length(name_idx)

  if (name_len > 1) {
    geo$oname <- base::apply(geo@data[, name_idx], 1, base::paste, collapse = " ")
  } else if (name_len == 1) {
    geo$oname <- geo@data[, name_idx]
  }

  base::colnames(geo@data) <- base::tolower(base::colnames(geo@data))

  geo
}

# get_geo_data(input)
# geo <- get_geo_data(input)
