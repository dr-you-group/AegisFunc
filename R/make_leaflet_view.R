make_leaflet_view <- function(input,
                              ...) {
  bbox <- input@bbox

  view <- base::list()

  view$lng <- base::mean(bbox[1, 1:2])
  view$lat <- base::mean(bbox[2, 1:2])
  view$zoom <- 7

  view
}

# make_leaflet_view(input)
# view <- make_leaflet_view(input)
