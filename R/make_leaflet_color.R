make_leaflet_color <- function(input,
                               ...) {
  palette <- input$palette
  domain <- input$domain
  n <- input$n

  color <- leaflet::colorQuantile(
    palette = palette,
    domain = NULL,
    n = 5
  )

  color
}

# make_leaflet_color(input)
# color <- make_leaflet_color(input)
