
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

We have tested with Microsoft SQL Server.

``` r
input <- base::list()
input$conn$dbms <- "sql server"
input$conn$path_to_driver <- getwd()
input$conn$connection_string <- "jdbc:sqlserver://[SERVER_IP]:[SERVER_PORT];databaseName=[CDM_DB_NAME]"
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

### Step 01. Table of Cohort

``` r
input <- base::list()
input$conn_info <- conn_info
input$query$cdm_database_schema <- "[CDM_DB_SCHEMA]"
input$query$reuslt_database_schema <- "[RESULT_DB_SCHEMA]"
input$query$target_cohort_definition_id <- ""
input$query$outcome_cohort_definition_id <- ""
input$query$cohort_start_date <- ""
input$query$cohort_end_date <- ""
input$query$time_at_risk_start_date <- ""
input$query$time_at_risk_end_date <- ""
input$query$time_at_risk_end_date_panel <- ""

map_table <- get_disease_map_table(input)
```

### Step 02. Adjust by age and sex

``` r
input <- base::list()
input$table <- map_table
input$mode <- "std" # "std" or "crd"
input$fraction <- 100000
input$conf_level <- 0.95

map_table_adjust <- calculate_adjust_age_sex_indirectly(input)
```

### Step 03. Calculate disease map

``` r
input <- base::list()
input$table <- map_table_adjust

map_derivatives <- calculate_disease_map(input)
```

### Step 04. Merge GADM with derivatives

This function is not implemented yet.

``` r
input <- base::list()
table <- map_derivatives$arranged_table
stats <- map_derivatives$stats

gadm_with_map <- base::list()
# gadm_with_map$data <- gadm + table
# gadm_with_map$stats <- stats
```

You can use GADM data in the next step.

``` r
input <- base::list()
input$gadm$country <- "KOR"
input$gadm$level <- 2

gadm <- read_gadm_data(input)
```

### Step 05. Plot

``` r
# input <- gadm_with_map
input <- base::list()
input$data <- gadm
input$data$name <- gadm$NAME_1
input$data$indicator <- stats::rnorm(n = nrow(gadm), 150, 30)

map_map <- get_disease_map_map(input)
map_map
```

## Disease Cluster

### Step 01. Table of Cohort

``` r
input <- base::list()
input$conn_info <- conn_info
input$query$cdm_database_schema <- "[CDM_DB_SCHEMA]"
input$query$reuslt_database_schema <- "[RESULT_DB_SCHEMA]"
input$query$target_cohort_definition_id <- ""
input$query$outcome_cohort_definition_id <- ""
input$query$cohort_start_date <- ""
input$query$cohort_end_date <- ""
input$query$time_at_risk_start_date <- ""
input$query$time_at_risk_end_date <- ""
input$query$time_at_risk_end_date_panel <- ""

cluster_table <- get_disease_cluster_table(input)
```

### Step 02. Adjust by age and sex

``` r
input <- base::list()
input$table <- cluster_table
input$mode <- "std" # "std" or "crd"
input$fraction <- 100000
input$conf_level <- 0.95

cluster_table_adjust <- calculate_adjust_age_sex_indirectly(input)
```

### Step 03. Calculate disease cluster

``` r
input <- base::list()
input$table <- cluster_table_adjust

cluster_derivatives <- calculate_disease_cluster(input)
```

### Step 04. Merge GADM with derivatives

This function is not implemented yet.

``` r
input <- base::list()
table <- cluster_derivatives$arranged_table
stats <- cluster_derivatives$stats

gadm_with_cluster <- base::list()
# gadm_with_cluster$data <- gadm + table
# gadm_with_cluster$stats <- stats
```

You can use GADM data in the next step.

``` r
input <- base::list()
input$gadm$country <- "KOR"
input$gadm$level <- 2

gadm <- read_gadm_data(input)
```

### Step 05. Plot

``` r
# input <- gadm_with_cluster
input <- base::list()
input$data <- gadm
input$data$name <- gadm$NAME_1
input$data$indicator <- stats::rnorm(n = nrow(gadm), 150, 30)

cluster_map <- get_disease_cluster_map(input)
cluster_map
```
