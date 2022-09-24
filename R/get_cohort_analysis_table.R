#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
get_cohort_analysis_table <- function(input,
                                      ...) {
  conn_info <- input$conn_info
  cdm_database_schema <- input$query$cdm_database_schema
  result_database_schema <- input$query$result_database_schema
  target_cohort_definition_id <- input$query$target_cohort_definition_id
  outcome_cohort_definition_id <- input$query$outcome_cohort_definition_id
  cohort_start_date <- input$query$cohort_start_date
  cohort_end_date <- input$query$cohort_end_date
  time_at_risk_start_date <- input$query$time_at_risk_start_date
  time_at_risk_end_date <- input$query$time_at_risk_end_date
  time_at_risk_end_date_panel <- input$query$time_at_risk_end_date_panel

  sql_file_name <- "query_cohort"

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

# get_cohort_analysis_table(input)
# table <- get_cohort_analysis_table(input)
