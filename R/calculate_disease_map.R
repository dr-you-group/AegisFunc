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

  result <- base::list()

  if(model == "spatial") {
    result <- run_inla(table, graph_file_path)
  } else if (model == "spatio-temporal") {
    years <- sort(unique(table$cohort_start_year))

    for(i in 1:length(years)) {
      idx <- table$cohort_start_year == years[i]

      result[years[i]] <- run_inla(table[idx,], graph_file_path)
    }
  }

  output <- result

  output
}

run_inla <- function(table, graph_file_path) {
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
  output$model <- model
  output$table <- table
  output$results <- results
  output$stats <- stats
  output$arranged_table <- arranged_table

  output
}
