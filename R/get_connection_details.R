#' Title
#'
#' @param ...
#' @param dbms
#' @param user
#' @param password
#' @param server
#' @param port
#' @param extra_settings
#' @param oracle_driver
#' @param path_to_driver
#' @param connection_string
#'
#' @return
#' @export
#'
#' @examples
get_connection_details <- function(dbms, user, password, server, port,
                                   extra_settings, oracle_driver,
                                   path_to_driver, connection_string,
                                   ...) {
  dbms <- dbms
  # user <- user
  # password <- password
  # server <- server
  # port <- base::as.numeric(port)
  # extra_settings <- extra_settings
  # oracle_driver <- oracle_driver
  path_to_driver <- path_to_driver
  connection_string <- connection_string

  if (
    base::is.null(path_to_driver) |
      base::length(base::list.files(path_to_driver, "^mssql-jdbc.*.jar$|^sqljdbc.*\\.jar$")) == 0
  ) {
    DatabaseConnector::downloadJdbcDrivers(
      dbms = dbms,
      pathToDriver = base::getwd(),
      method = "auto"
    )

    path_to_driver <- base::getwd()
  }

  conn_info <- DatabaseConnector::createConnectionDetails(
    dbms = dbms,
    user = user,
    password = password,
    server = server,
    port = port,
    extraSettings = extra_settings,
    oracleDriver = oracle_driver,
    pathToDriver = path_to_driver,
    connectionString = connection_string
  )

  conn_info
}
