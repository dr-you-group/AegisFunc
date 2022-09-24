#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
merge_geo_with_deriv <- function(input,
                                 ...) {
  geo <- input$geo
  deriv <- input$deriv

  data <- sp::merge(geo, deriv, by = "oid")

  data
}

# merge_geo_with_deriv(input)
# data <- merge_geo_with_deriv(input)
