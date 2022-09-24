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

  formula <- outcome_count ~ 1 +
    INLA::f(oid, model = "iid") +
    INLA::f(oid, model = "bym2", graph = graph_file_path, adjust.for.con.comp = TRUE)
  family <- "poisson"
  control_predictor <- base::list(compute = TRUE)

  results <- INLA::inla(
    formula = formula,
    family = family,
    data = table,
    E = expected,
    control.predictor = control_predictor
  )

  stats <- base::list()
  stats$rr_mean <- results$map.summary.fitted.values[, 1]

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
