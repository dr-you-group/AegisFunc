#' Title
#'
#' @param ...
#' @param data
#' @param stats
#' @param color_type
#' @param color_param
#'
#' @return
#' @export
#'
#' @examples
get_leaflet_map <- function(data, stats,
                            color_type, color_param,
                            ...) {
  color <- AegisFunc::make_leaflet_color(color_type, color_param)
  popup <- AegisFunc::make_leaflet_popup(data, stats)
  bound <- AegisFunc::make_leaflet_bound(data)

  map <- AegisFunc::make_leaflet_map(data, color, popup, bound)

  map
}
