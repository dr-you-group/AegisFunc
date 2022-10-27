#' Title
#'
#' @param ...
#' @param table
#' @param model
#'
#' @return
#' @export
#'
#' @examples
calculate_disease_cluster <- function(model = "spatial", table,
                                      ...) {
  model <- model
  table <- table

  result <- base::list()

  table <- table[table$outcome_count > 0,]

  if(model == "spatial") {
    result <- run_kulldorff(table)
  } else if (model == "spatio-temporal") {
    years <- sort(unique(table$cohort_start_year))

    for(i in 1:length(years)) {
      message("year ", years[i])

      idx <- table$cohort_start_year == years[i]

      result <- append(result, list(run_kulldorff(table[idx,])))
    }

    names(result) <- years
  }

  output <- result

  output
}

run_kulldorff <- function(table) {
  results <- SpatialEpi::kulldorff(
    geo = SpatialEpi::latlong2grid(table[, c("longitude", "latitude")]),
    cases = base::tapply(table$outcome_count, table$oid, sum),
    population = base::tapply(table$target_count, table$oid, sum),
    expected.cases = table$expected,
    pop.upper.bound = 0.1,
    n.simulations = 999,
    alpha.level = 0.05,
    plot = FALSE
  )

  stats <- base::as.data.frame(results$most.likely.cluster)
  for (i in 1:base::length(results$secondary.clusters)) {
    stats <- base::rbind(stats, base::as.data.frame(results$secondary.clusters[[i]]))
  }

  names(stats) <- c("idx", "population", "number_of_cases", "expected_cases", "smr", "log_likelihood_ratio", "monte_carlo_rank", "p_value")

  empty <- base::data.frame(idx = base::seq(1, base::nrow(table), 1))
  stats <- base::merge(stats, empty, by = "idx", all.y = TRUE)

  arranged_table <- table
  arranged_table$indicator <- NA
  arranged_table[!is.na(stats$log_likelihood_ratio), ]$indicator <- base::seq(1, base::sum(!is.na(stats$log_likelihood_ratio)), 1)

  output <- base::list()
  output$table <- table
  output$results <- results
  output$stats <- stats
  output$arranged_table <- arranged_table

  output
}
