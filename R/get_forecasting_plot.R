#' Title
#'
#' @param data
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
get_forecasting_plot <- function(data,
                                 ...) {
  data <- data

  plot <- ggplot2::ggplot(data = data, ggplot2::aes(x = date, y = ts)) +
    ggplot2::geom_point() +
    ggplot2::geom_line(ggplot2::aes(x = date, y = mean.i1)) +
    ggplot2::geom_ribbon(ggplot2::aes(x = date, ymin = lo.i1, ymax = up.i1), alpha = 0.2) +
    # ggplot2::facet_wrap(~variable, scales = "free") +
    ggplot2::xlab("Year") +
    ggplot2::ylab("Outcome") +
    ggplot2::theme_bw()

  plot
}
