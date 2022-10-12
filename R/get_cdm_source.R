#' Title
#'
#' @param ...
#' @param conn_info
#' @param cdm_database_schema
#'
#' @return
#' @export
#'
#' @examples
get_cdm_source <- function(conn_info, cdm_database_schema,
                           ...) {
  conn_info <- conn_info
  cdm_database_schema <- cdm_database_schema

  sql_file_name <- "query_cdm_source"

  table <- AegisFunc::query_cdm_database(
    sql_file_name = sql_file_name,
    conn_info = conn_info,
    cdm_database_schema = cdm_database_schema
  )

  table
}
