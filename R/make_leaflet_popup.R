make_leaflet_popup <- function(input,
                               ...) {
  name <- input$data$oname
  indicator <- input$data$indicator
  stats <- input$stats

  popup <- base::paste0(
    "<strong>Name: </strong>", name, "<br>",
    "<strong>Indicator: </strong>", base::round(indicator, 2)
  )

  if (base::length(stats) > 1) {
    popup <- base::paste0(popup, "<br>", base::apply(stats[, -1], 1, p, pre = "<strong>", post = ": </strong>", collapse = "<br>"))
  }

  popup
}

# make_leaflet_popup(input)
# popup <- make_leaflet_popup(input)

p <- function(x, pre, post, collapse) {
  paste0(pre, names(x), post, x, collapse = collapse)
}

# d <- data.frame(a = 1:3, b = c('a','b','c'), c = c('d','e','f'), d = c('g','h','i'))
# a <- apply(d, 1, p, pre = "<strong>", post = ": </strong>", collapse = "<br>")

# pop <- c("<pop1>", "<pop2>", "<pop3>")
# paste0(pop, "<br>", apply(d, 1, p, pre = "<strong>", post = ": </strong>", collapse = "<br>"))
