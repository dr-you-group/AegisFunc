#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
calculate_disease_map <- function(input,
                                  ...) {
  table <- input$table
  graph_file_path <- input$graph_file_path

  table$oid2 <- table$oid

  results <- INLA::inla(
    formula = outcome_count ~ 1 +
      f(oid, model = "iid") +
      f(oid2, model = "bym2", graph = graph_file_path, adjust.for.con.comp = TRUE),
    family = "poisson",
    data = table,
    E = expected,
    control.predictor = base::list(compute = TRUE)
  )

  stats <- base::list()
  stats$rr_mean <- results$summary.fitted.values$mean

  arranged_table <- table
  arranged_table$indicator <- stats$rr_mean

  output <- base::list()
  output$table <- table
  output$results <- results
  output$stats <- stats
  output$arranged_table <- arranged_table

  output
}

# calculate_disease_map(input)
# output <- calculate_disease_map(input)
