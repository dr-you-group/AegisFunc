get_connection_details <- function(input,
                                   ...) {
  dbms <- input$conn$dbms
  user <- input$conn$user
  password <- input$conn$password
  server <- input$conn$server
  port <- input$conn$port
  extra_settings <- input$conn$extra_settings
  oracle_driver <- input$conn$oracle_driver
  path_to_driver <- input$conn$path_to_driver
  connection_string <- input$conn$connection_string

  if (base::is.null(path_to_driver)) {
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

# get_connection_details(input)
# conn_info <- get_connection_details(input)
