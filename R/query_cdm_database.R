query_cdm_database <- function(sql_file_name = NULL,
                               conn_info = NULL,
                               sql = NULL,
                               error_report_file = base::file.path(base::getwd(), "errorReportSql.txt"),
                               snake_case_to_camel_case = FALSE,
                               integer_as_numeric = base::getOption("databaseConnectorIntegerAsNumeric", default = TRUE),
                               integer64_as_numeric = base::getOption("databaseConnectorInteger64AsNumeric", default = TRUE),
                               ...) {
  # sql_file_path <- base::system.file("extdata", base::paste0("sql/sql_server/", sql_file_name, ".sql"), package = "AegisFunc")
  sql_file_path <- base::file.path(base::getwd(), "inst", "extdata", "sql", "sql_server", base::paste0(sql_file_name, ".sql"))
  print(sql_file_path)

  sql <- SqlRender::readSql(sourceFile = sql_file_path)
  sql <- SqlRender::renderSql(sql = sql, ...)$sql
  if (conn_info$dbms != "sql server") {
    sql <- SqlRender::translateSql(
      sql = sql,
      targetDialect = conn_info$dbms,
      oracleTempSchema = oracle_temp_schema
    )
  }

  conn <- DatabaseConnector::connect(conn_info)
  query <- DatabaseConnector::querySql(
    connection = conn,
    sql = sql,
    errorReportFile = error_report_file,
    snakeCaseToCamelCase = snake_case_to_camel_case,
    integerAsNumeric = integer_as_numeric,
    integer64AsNumeric = integer64_as_numeric
  )
  DatabaseConnector::disconnect(conn)

  query
}

# query_cdm_database()
# query <- query_cdm_database()
