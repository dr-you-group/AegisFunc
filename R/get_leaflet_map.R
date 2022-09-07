get_leaflet_map <- function(input,
                            ...) {
  data <- input$data
  stats <- input$stats
  color <- base::list()
  color$palette <- "Greens"
  color$domain <- NULL
  color$n <- 9

  color <- make_leaflet_color(color)
  popup <- make_leaflet_popup(input)
  bound <- make_leaflet_bound(data)

  input$color <- color
  input$popup <- popup
  input$bound <- bound

  map <- make_leaflet_map(input)

  map
}

# get_leaflet_map(input)
# map <- get_leaflet_map(input)
