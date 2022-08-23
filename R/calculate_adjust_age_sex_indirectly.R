calculate_adjust_age_sex_indirectly <- function(input,
                                                ...) {
  table <- input$table
  mode <- input$mode
  fraction <- input$fraction
  conf_level <- input$conf_level

  zv <- stats::qnorm(0.5 * (1 + conf_level))

  # Calculation to indirect age and gender standardization rate
  table_std <- base::data.frame(table)
  table_std <- dplyr::group_by(table_std, AGE_CATEGORY, SEX_CATEGORY)
  table_std <- dplyr::summarise(
    table_std,
    target_sum = base::sum(TARGET_COUNT),
    outcome_sum = base::sum(OUTCOME_COUNT)
  )
  table_std$rate <- table_std$outcome_sum / table_std$target_sum

  table <- dplyr::left_join(table, table_std, by = base::c("AGE_CATEGORY", "SEX_CATEGORY"))
  table$expected <- table$TARGET_COUNT * table$rate

  table <- dplyr::group_by(table, LOCATION_ID)
  table <- dplyr::summarise(
    table,
    target_count = base::sum(TARGET_COUNT),
    outcome_count = base::sum(OUTCOME_COUNT),
    expected = base::sum(expected)
  )

  if (mode == "crd") {
    # Crude stat
    table$expected <- table$target_count * (base::sum(table$outcome_count) / base::sum(table$target_count))
  }

  table$sir <- table$outcome_count / table$expected

  table$logsirlower <- base::log(table$sir) - zv * (1 / base::sqrt(table$outcome_count))
  table$logsirupper <- base::log(table$sir) + zv * (1 / base::sqrt(table$outcome_count))

  table$sirlower <- base::exp(table$logsirlower)
  table$sirupper <- base::exp(table$logsirupper)

  # Proportion
  table$prop <- ((base::sum(table$outcome_count) / base::sum(table$target_count)) * table$sir) * fraction
  table$proplower <- ((base::sum(table$outcome_count) / base::sum(table$target_count)) * table$sirlower) * fraction
  table$propupper <- ((base::sum(table$outcome_count) / base::sum(table$target_count)) * table$sirupper) * fraction

  table
}

# calculate_adjust_age_sex_indirectly(input)
# table <- calculate_adjust_age_sex_indirectly(input)
