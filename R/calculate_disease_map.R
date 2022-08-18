calculate_disease_map <- function(input,
                                  ...) {
  table <- input$table

  formula <- outcome_count ~ 1 +
    # INLA::f(OBJECTID, model = "iid") +
    # INLA::f(id2, model = "bym2", graph = file.path(MAP.path, MAP.file), adjust.for.con.comp = TRUE) +
    INLA::f(location_id, model = "iid")
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
