% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query_cdm_database.R
\name{query_cdm_database}
\alias{query_cdm_database}
\title{Title}
\usage{
query_cdm_database(
  sql_file_name = NULL,
  conn_info = NULL,
  sql = NULL,
  error_report_file = base::file.path(base::getwd(), "errorReportSql.txt"),
  snake_case_to_camel_case = FALSE,
  integer_as_numeric = base::getOption("databaseConnectorIntegerAsNumeric", default =
    TRUE),
  integer64_as_numeric = base::getOption("databaseConnectorInteger64AsNumeric", default =
    TRUE),
  ...
)
}
\arguments{
\item{...}{}
}
\description{
Title
}
