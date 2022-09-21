calculate_disease_cluster <- function(input,
                                      ...) {
  table <- input$table

  geo <- SpatialEpi::latlong2grid(table[, c("longitude", "latitude")])
  cases <- base::tapply(table$outcome_count, table$oid, sum)
  population <- base::tapply(table$target_count, table$oid, sum)
  expected <- table$expected
  pop_upper_bound <- 0.1
  n_simulations <- 999
  alpha_level <- 0.05
  plot <- FALSE

  results <- SpatialEpi::kulldorff(
    geo = geo,
    cases = cases,
    population = population,
    expected.cases = expected,
    pop.upper.bound = pop_upper_bound,
    n.simulations = n_simulations,
    alpha.level = alpha_level,
    plot = plot
  )

  stats <- base::as.data.frame(results$most.likely.cluster)
  for(i in 1:base::length(results$secondary.clusters)) {
    stats <- base::rbind(stats, base::as.data.frame(results$secondary.clusters[[i]]))
  }

  names(stats) <- c("idx", "population", "number_of_cases", "expected_cases", "smr", "log_likelihood_ratio", "monte_carlo_rank", "p_value")

  empty <- base::data.frame(idx = base::seq(1, base::nrow(table), 1))
  stats <- base::merge(stats, empty, by = "idx", all.y = TRUE)

  arranged_table <- table
  arranged_table$indicator <- NA
  arranged_table[!is.na(stats$log_likelihood_ratio), ]$indicator <- base::seq(1, base::sum(!is.na(stats$log_likelihood_ratio)), 1)

  # stats$indicator <- NA
  # stats[!is.na(stats$log_likelihood_ratio), ]$indicator <- base::seq(1, base::sum(!is.na(stats$log_likelihood_ratio)), 1)


  output <- base::list()
  output$table <- table
  output$results <- results
  output$stats <- stats
  output$arranged_table <- arranged_table

  output
}

# calculate_disease_cluster(input)
# output <- calculate_disease_cluster(input)
