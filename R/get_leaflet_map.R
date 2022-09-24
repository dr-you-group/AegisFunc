#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
get_leaflet_map <- function(input,
                            ...) {
  data <- input$data
  stats <- input$stats
  color <- base::list()
  color$palette <- "Greens"
  color$domain <- NULL
  color$n <- 9

  color <- AegisFunc::make_leaflet_color(color)
  popup <- AegisFunc::make_leaflet_popup(input)
  bound <- AegisFunc::make_leaflet_bound(data)

  input$color <- color
  input$popup <- popup
  input$bound <- bound

  map <- AegisFunc::make_leaflet_map(input)

  map
}

# get_leaflet_map(input)
# map <- get_leaflet_map(input)
