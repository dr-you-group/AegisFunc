#' Title
#'
#' @param ...
#' @param table
#' @param mode
#' @param fraction
#' @param conf_level
#'
#' @return
#' @export
#'
#' @examples
calculate_adjust_age_sex_indirectly <- function(table, mode, fraction, conf_level,
                                                ...) {
  table <- table
  mode <- mode
  fraction <- base::as.numeric(fraction)
  conf_level <- base::as.numeric(conf_level)

  zv <- stats::qnorm(0.5 * (1 + conf_level))

  # Calculation to indirect age and gender standardization rate
  table_std <- base::data.frame(table)
  table_std <- dplyr::group_by(table_std, age_category, sex_category)
  table_std <- dplyr::summarise(
    table_std,
    target_sum = base::sum(target_count),
    outcome_sum = base::sum(outcome_count)
  )
  table_std$rate <- table_std$outcome_sum / table_std$target_sum

  table <- dplyr::left_join(table, table_std, by = base::c("age_category", "sex_category"))
  table$expected <- table$target_count * table$rate

  table <- dplyr::group_by(table, oid, latitude, longitude)
  table <- dplyr::summarise(
    table,
    target_count = base::sum(target_count),
    outcome_count = base::sum(outcome_count),
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
