#' Title
#'
#' @param ...
#' @param geo
#' @param deriv
#'
#' @return
#' @export
#'
#' @examples
merge_geo_with_deriv <- function(geo, deriv,
                                 ...) {
  geo <- geo
  deriv <- deriv

  data <- sp::merge(geo, deriv, by = "oid")

  data
}
