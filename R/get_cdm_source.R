#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
get_cdm_source <- function(input,
                           ...) {
  conn_info <- input$conn_info
  cdm_database_schema <- input$query$cdm_database_schema

  sql_file_name <- "query_cdm_source"

  table <- AegisFunc::query_cdm_database(
    sql_file_name = sql_file_name,
    conn_info = conn_info,
    cdm_database_schema = cdm_database_schema
  )

  table
}

# get_cdm_source(input)
# table <- get_cdm_source(input)
