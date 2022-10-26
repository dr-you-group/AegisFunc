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
calculate_count_with_geo_oid <- function(model = "spatial", table,
                                         ...) {
  model <- model
  table <- table

  table$target_count[is.na(table$target_count)] <- 1
  table$outcome_count[is.na(table$outcome_count)] <- 0
  table$latitude[is.na(table$latitude)] <- table$lat[is.na(table$latitude)]
  table$longitude[is.na(table$longitude)] <- table$long[is.na(table$longitude)]
  table$age_category[is.na(table$age_category)] <- 0
  table$sex_category[is.na(table$sex_category)] <- 0
  if(model == "spatio-temporal") {
    table$cohort_start_year[is.na(table$cohort_start_year)] <- 0
  }

  formula_opts <- base::list(
    "spatial" = cbind(target_count, outcome_count) ~ oid + latitude + longitude +
      age_category + sex_category,
    "spatio-temporal" = cbind(target_count, outcome_count) ~ oid + latitude + longitude +
      cohort_start_year + age_category + sex_category
  )

  table <- stats::aggregate(
    formula_opts[model][[1]],
    data = table,
    FUN = base::sum,
    na.action = na.pass
  )

  table
}
