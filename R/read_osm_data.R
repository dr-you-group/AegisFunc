read_osm_data <- function(input,
                          ...) {
  name <- input$geo$name
  country <- input$geo$country
  level <- input$geo$level
  download <- TRUE
  path <- base::getwd()
  version <- 3.6
  type <- "sp"

  q <- osmdata::opq(country)
  q <- osmdata::add_osm_feature()

  geo <- osmdata::osmdata_sp(q)

  geo
}

# read_osm_data(input)
# geo <- read_osm_data(input)
