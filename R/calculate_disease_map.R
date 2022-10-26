#' Title
#'
#' @param ...
#' @param table
#' @param graph_file_path
#' @param model
#'
#' @return
#' @export
#'
#' @examples
calculate_disease_map <- function(model = "spatial", table, graph_file_path,
                                  ...) {
  model <- model
  table <- table
  graph_file_path <- graph_file_path

  results <- NULL
  stats <- NULL
  arranged_table <- NULL

  if(model == "spatial") {
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
  } else if (model == "spatio-temporal") {
    # code here
  }

  output <- base::list()
  output$model <- model
  output$table <- table
  output$results <- results
  output$stats <- stats
  output$arranged_table <- arranged_table

  output
}
