#' Title
#'
#' @param ...
#' @param conn_info
#' @param result_database_schema
#'
#' @return
#' @export
#'
#' @examples
get_cohort_list_table <- function(conn_info, result_database_schema,
                                  ...) {
  conn_info <- conn_info
  result_database_schema <- result_database_schema

  sql_file_name <- "query_cohort_definition"

  table <- AegisFunc::query_cdm_database(
    sql_file_name = sql_file_name,
    conn_info = conn_info,
    result_database_schema = result_database_schema
  )

  table
}
