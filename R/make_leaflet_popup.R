#' Title
#'
#' @param ...
#' @param data
#' @param stats
#'
#' @return
#' @export
#'
#' @examples
make_leaflet_popup <- function(data, stats,
                               ...) {
  name <- data$oname
  indicator <- data$indicator
  stats <- stats

  popup <- base::paste0(
    "<strong>Name: </strong>", name, "<br>",
    "<strong>Indicator: </strong>", base::round(indicator, 2)
  )

  if (base::length(stats) > 1) {
    popup <- base::paste0(popup, "<br>", base::apply(stats[, -1], 1, p, pre = "<strong>", post = ": </strong>", collapse = "<br>"))
  }

  popup
}

p <- function(x, pre, post, collapse) {
  paste0(pre, names(x), post, x, collapse = collapse)
}

# d <- data.frame(a = 1:3, b = c('a','b','c'), c = c('d','e','f'), d = c('g','h','i'))
# a <- apply(d, 1, p, pre = "<strong>", post = ": </strong>", collapse = "<br>")

# pop <- c("<pop1>", "<pop2>", "<pop3>")
# paste0(pop, "<br>", apply(d, 1, p, pre = "<strong>", post = ": </strong>", collapse = "<br>"))
