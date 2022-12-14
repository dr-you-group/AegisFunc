#' Title
#'
#' @param ...
#' @param conn_info
#' @param cdm_database_schema
#' @param result_database_schema
#' @param target_cohort_definition_id
#' @param outcome_cohort_definition_id
#' @param cohort_start_date
#' @param cohort_end_date
#' @param time_at_risk_start_date
#' @param time_at_risk_end_date
#' @param time_at_risk_end_date_panel
#' @param model
#'
#' @return
#' @export
#'
#' @examples
get_cohort_analysis_table <- function(model = "spatial",
                                      conn_info = NULL,
                                      cdm_database_schema = NULL,
                                      result_database_schema = NULL,
                                      target_cohort_definition_id = NULL,
                                      outcome_cohort_definition_id = NULL,
                                      cohort_start_date = NULL,
                                      cohort_end_date = NULL,
                                      time_at_risk_start_date = NULL,
                                      time_at_risk_end_date = NULL,
                                      time_at_risk_end_date_panel = NULL,
                                      ...) {
  model <- model
  conn_info <- conn_info
  cdm_database_schema <- cdm_database_schema
  result_database_schema <- result_database_schema
  target_cohort_definition_id <- target_cohort_definition_id
  outcome_cohort_definition_id <- outcome_cohort_definition_id
  cohort_start_date <- cohort_start_date
  cohort_end_date <- cohort_end_date
  time_at_risk_start_date <- time_at_risk_start_date
  time_at_risk_end_date <- time_at_risk_end_date
  time_at_risk_end_date_panel <- time_at_risk_end_date_panel

  sql_file_names <- base::list(
    "spatial" = "query_cohort_for_spatial",
    "spatio-temporal" = "query_cohort_for_spatio_temporal",
    "temporal" = "query_cohort_for_temporal"
  )
  sql_file_name <- sql_file_names[model][[1]]

  table <- AegisFunc::query_cdm_database(
    sql_file_name = sql_file_name,
    conn_info = conn_info,
    cdm_database_schema = cdm_database_schema,
    result_database_schema = result_database_schema,
    target_cohort_definition_id = target_cohort_definition_id,
    outcome_cohort_definition_id = outcome_cohort_definition_id,
    cohort_start_date = cohort_start_date,
    cohort_end_date = cohort_end_date,
    time_at_risk_start_date = time_at_risk_start_date,
    time_at_risk_end_date = time_at_risk_end_date,
    time_at_risk_end_date_panel = time_at_risk_end_date_panel
  )

  table
}
