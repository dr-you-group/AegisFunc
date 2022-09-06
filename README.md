
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AegisFunc

<!-- badges: start -->
<!-- badges: end -->

AegisFunc is a tool for Spatio-temporal epidemiology based on OHDSI CDM.
AegisFunc originated from the Aegis project that is an open-source
spatial analysis tool based on CDM. <https://github.com/ABMI/Aegis>.

## Installation

You can install the development version of AegisFunc like so:

``` r
devtools::install()
```

We recommend using it by loading all functions.

``` r
devtools::load_all()
```

## Example

### Database connection

-   Connection string of SQL Server:
    “jdbc:sqlserver://localhost:1433;databaseName=cdm;user=user;password=password”
-   Connection string of PostgreSQL:
    “jdbc:postgresql://localhost:5432/cdm?user=user&password=password”

We have tested with PostgreSQL.

``` r
input <- base::list()
input$conn$dbms <- "postgresql"
input$conn$path_to_driver <- getwd()
input$conn$connection_string <- "jdbc:postgresql://[SERVER_IP]:[SERVER_PORT]/[CDM_DB_NAME]"
input$conn$user <- "****"
input$conn$password <- "****"

conn_info <- get_connection_details(input)
```

### Load cohort list

Query defined cohort list.

``` r
input <- base::list()
input$conn_info <- conn_info
input$query$result_database_schema <- "[RESULT_DB_SCHEMA]"

table <- get_cohort_list_table(input)
```

## Disease Map

### Step 01. Get cohort table

``` r
input <- base::list()
input$conn_info <- conn_info
input$query$cdm_database_schema <- "[CDM_DB_SCHEMA]"
input$query$result_database_schema <- "[RESULT_DB_SCHEMA]"
input$query$target_cohort_definition_id <- "1"
input$query$outcome_cohort_definition_id <- "2"
input$query$cohort_start_date <- "2020-01-01"
input$query$cohort_end_date <- "2020-12-31"
input$query$time_at_risk_start_date <- "0"
input$query$time_at_risk_end_date <- "0"
input$query$time_at_risk_end_date_panel <- "cohort_start_date" # "cohort_start_date" or "cohort_end_date"

map_table <- get_disease_map_table(input)
```

### Step 02. Merge Table with Geo data

Read Geo data

-   [GADM 3.6](https://gadm.org/)
-   [Administrative area data of South
    Korea](http://www.gisdeveloper.co.kr/?p=2332)

``` r
input <- base::list()
input$geo$name <- "KOR" # "GADM" or "KOR"
input$geo$country <- "KOR"
input$geo$level <- 2

geo <- get_geo_data(input)
```

Merge Map Table and Geo data

``` r
input$latlong <- map_table
input$geo <- geo

geo_map <- map_latlong_geo(input)
```

Arrange table

``` r
input$table <- geo_map
map_table_arr <- calculate_count_with_geo_oid(input)
```

### Step 03. Adjust by age and sex

``` r
input <- base::list()
input$table <- map_table_arr
input$adj$mode <- "std" # "std" or "crd"
input$adj$fraction <- 100000
input$adj$conf_level <- 0.95

map_table_adj <- calculate_adjust_age_sex_indirectly(input)
```

### Step 04. Calculate disease map

``` r
input <- base::list()
input$geo <- geo

graph_file_path <- trans_geo_to_graph(input)

input <- base::list()
input$table <- map_table_adj
input$graph_file_path <- graph_file_path

map_deriv <- calculate_disease_map(input)
```

### Step 05. Plot

``` r
input <- base::list()
input$data <- geo
# input$data$indicator <- map_deriv$arranged_table$indicator
# input$stats <- map_deriv$stats
input$data$indicator <- stats::rnorm(n = length(geo), 150, 30)

map_map <- get_disease_map_map(input)
map_map
```

## Disease Cluster

### Step 01. Get cohort table

``` r
input <- base::list()
input$conn_info <- conn_info
input$query$cdm_database_schema <- "[CDM_DB_SCHEMA]"
input$query$result_database_schema <- "[RESULT_DB_SCHEMA]"
input$query$target_cohort_definition_id <- "1"
input$query$outcome_cohort_definition_id <- "2"
input$query$cohort_start_date <- "2020-01-01"
input$query$cohort_end_date <- "2020-12-31"
input$query$time_at_risk_start_date <- "0"
input$query$time_at_risk_end_date <- "0"
input$query$time_at_risk_end_date_panel <- "cohort_start_date" # "cohort_start_date" or "cohort_end_date"

cluster_table <- get_disease_cluster_table(input)
```

### Step 02. Merge Table with Geo data

Read Geo data

-   [GADM 3.6](https://gadm.org/)
-   [Administrative area data of South
    Korea](http://www.gisdeveloper.co.kr/?p=2332)

``` r
input <- base::list()
input$geo$name <- "KOR" # "GADM" or "KOR"
input$geo$country <- "KOR"
input$geo$level <- 2

geo <- get_geo_data(input)
```

Merge Cluster Table and Geo data

``` r
input$latlong <- cluster_table
input$geo <- geo

geo_map <- map_latlong_geo(input)
```

Arrange table

``` r
input$table <- geo_map
cluster_table_arr <- calculate_count_with_geo_oid(input)
```

### Step 03. Adjust by age and sex

``` r
input <- base::list()
input$table <- cluster_table_arr
input$adj$mode <- "std" # "std" or "crd"
input$adj$fraction <- 100000
input$adj$conf_level <- 0.95

cluster_table_adj <- calculate_adjust_age_sex_indirectly(input)
```

### Step 04. Calculate disease cluster

``` r
input <- base::list()
input$table <- cluster_table_adj

cluster_deriv <- calculate_disease_cluster(input)
```

### Step 05. Plot

``` r
input <- base::list()
input$data <- geo
# input$data$indicator <- cluster_deriv$arranged_table$indicator
# input$stats <- cluster_deriv$stats
input$data$indicator <- stats::rnorm(n = length(geo), 150, 30)

cluster_map <- get_disease_cluster_map(input)
cluster_map
```
