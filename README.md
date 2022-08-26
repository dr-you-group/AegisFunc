
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

### Step 02. Adjust by age and sex

``` r
input <- base::list()
input$table <- map_table
input$adj$mode <- "std" # "std" or "crd"
input$adj$fraction <- 100000
input$adj$conf_level <- 0.95

map_table_adjust <- calculate_adjust_age_sex_indirectly(input)
```

### Step 03-1. Merge Table with GIS (GADM)

Read GADM

``` r
input <- base::list()
input$gadm$country <- "KOR"
input$gadm$level <- 2

gadm <- read_gadm_data(input)
```

This function is not implemented yet.

``` r
# map_table_adjust_gadm <- table + gadm
```

You can use GADM data in the plot step.

### Step 03-2. Merge Table with GIS (OpenStreetMap)

Read OSM

``` r
# input <- base::list()
# input$osm$country <- "KOR"
# input$osm$level <- 2

osm <- read_osm_data(input)
```

This function is not implemented yet.

``` r
# map_table_adjust_osm <- table + osm
```

You can use GADM data in the plot step.

### Step 04. Calculate disease map

``` r
input <- base::list()
input$gadm$country <- "KOR"
input$gadm$level <- 2
graph_file_path <- trans_gadm_to_graph(input)

input <- base::list()
input$table <- map_table_adjust # map_table_adjust_gadm or map_table_adjust_osm
input$graph_file_path <- graph_file_path

map_derivatives <- calculate_disease_map(input)
```

### Step 05. Plot

``` r
# input <- base::list()
# table <- map_derivatives$arranged_table
# stats <- map_derivatives$stats
# input <- map_derivatives
input <- base::list()
input$data <- gadm
input$data$name <- gadm$NAME_1
input$data$indicator <- stats::rnorm(n = nrow(gadm), 150, 30)

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

### Step 02. Adjust by age and sex

``` r
input <- base::list()
input$table <- cluster_table
input$adj$mode <- "std" # "std" or "crd"
input$adj$fraction <- 100000
input$adj$conf_level <- 0.95

cluster_table_adjust <- calculate_adjust_age_sex_indirectly(input)
```

### Step 03-1. Merge Table with GIS (GADM)

Read GADM

``` r
input <- base::list()
input$gadm$country <- "KOR"
input$gadm$level <- 2

gadm <- read_gadm_data(input)
```

This function is not implemented yet.

``` r
# cluster_table_adjust_gadm <- table + gadm
```

You can use GADM data in the plot step.

### Step 03-2. Merge Table with GIS (OpenStreetMap)

Read OSM

``` r
# input <- base::list()
# input$osm$country <- "KOR"
# input$osm$level <- 2

osm <- read_osm_data(input)
```

This function is not implemented yet.

``` r
# cluster_table_adjust_osm <- table + osm
```

You can use GADM data in the plot step.

### Step 04. Calculate disease map

``` r
input <- base::list()
input$table <- cluster_table_adjust # cluster_table_adjust_gadm or cluster_table_adjust_osm

cluster_derivatives <- calculate_disease_cluster(input)
```

### Step 05. Plot

``` r
# input <- base::list()
# table <- cluster_derivatives$arranged_table
# stats <- cluster_derivatives$stats
# input <- cluster_derivatives
input <- base::list()
input$data <- gadm
input$data$name <- gadm$NAME_1
input$data$indicator <- stats::rnorm(n = nrow(gadm), 150, 30)

cluster_map <- get_disease_cluster_map(input)
cluster_map
```
