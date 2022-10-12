
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AegisFunc

<!-- badges: start -->
<!-- badges: end -->

AegisFunc is a tool for Spatio-temporal epidemiology based on OHDSI CDM
v5.4.0.  
AegisFunc originated from the Aegis project that is an open-source
spatial analysis tool based on CDM. <https://github.com/ABMI/Aegis>.

## Requirements

### OHDSI CDM v5.4.0

-   We use latitude and longitude fields in Location table (updated on
    v5.4.0).

### INLA package

-   INLA package is not supported by CRAN.  
-   You can install manually from the r-inla repository  

``` r
install.packages("INLA", repos = c(getOption("repos"), INLA = "https://inla.r-inla-download.org/R/stable"), dep = TRUE)
```

### R v4.2

-   Latest version of INLA requires R v4.2 or above

## Installation

You can install the development version of AegisFunc like so:

``` r
devtools::install()
```

## Load

Load AegisFunc package before use.

``` r
library(AegisFunc)
```

## Check your CDM database

### Database connection

-   Connection string of SQL Server:
    “jdbc:sqlserver://localhost:1433;databaseName=cdm;user=user;password=password”  
-   Connection string of PostgreSQL:
    “jdbc:postgresql://localhost:5432/cdm?user=user&password=password”

We have tested with SQL Server 2019.

``` r
dbms <- "sql server"
path_to_driver <- getwd()
connection_string <- "jdbc:sqlserver://[SERVER_IP]:[SERVER_PORT];user=[USER_ID];password=[USER_PW];databaseName=[CDM_DB_NAME]"

conn_info <- get_connection_details(
  dbms = dbms,
  path_to_driver = path_to_driver,
  connection_string = connection_string
)
```

### Check CDM version

You must confirm your CDM version.  
Because we **only support for CDM v5.4.0 or above**.

``` r
conn_info <- conn_info
cdm_database_schema <- "[CDM_DB_SCHEMA]"

cdm_source <- get_cdm_source(
  conn_info = conn_info,
  cdm_database_schema = cdm_database_schema
)
cdm_version <- cdm_source[c("cdm_version")]
```

### Load cohort list

Query defined cohort list.

``` r
conn_info <- conn_info
result_database_schema <- "[RESULT_DB_SCHEMA]"

cohort_list <- get_cohort_list_table(
  conn_info = conn_info,
  result_database_schema = result_database_schema
)
```

## Disease Map/Cluster

### Step 01. Prepare Data

Get cohort table from CDM/Atlas database

``` r
conn_info <- conn_info
cdm_database_schema <- "[CDM_DB_SCHEMA]"
result_database_schema <- "[RESULT_DB_SCHEMA]"
target_cohort_definition_id <- "1"
outcome_cohort_definition_id <- "2"
cohort_start_date <- "2020-01-01"
cohort_end_date <- "2020-12-31"
time_at_risk_start_date <- "0"
time_at_risk_end_date <- "0"
time_at_risk_end_date_panel <- "cohort_start_date" # "cohort_start_date" or "cohort_end_date"

cohort_table <- get_cohort_analysis_table(
  conn_info = conn_info,
  cdm_database_schema = cdm_database_schema,
  result_database_schema = result_database_schema,
  target_cohort_definition_id = target_cohort_definition_id,
  outcome_cohort_definition_id = outcome_cohort_definition_id,
  cohort_start_date = cohort_start_date,
  cohort_end_date = cohort_end_date,
  time_at_risk_start_date = time_at_risk_start_date,
  time_at_risk_end_date = time_at_risk_end_date,
  time_at_risk_end_date_panel = time_at_risk_end_date_panel
)
```

Read geo data

-   [GADM 3.6](https://gadm.org/)  
-   [Administrative area data of South
    Korea](http://www.gisdeveloper.co.kr/?p=2332)

``` r
name <- "KOR" # "GADM" or "KOR"
country <- "KOR"
level <- "2"

geo <- get_geo_data(
  name = name,
  country = country,
  level = level
)
```

Map cohort table (lat/long) with geo data

``` r
latlong <- cohort_table
geo <- geo

geo_map <- map_latlong_geo(
  latlong = latlong,
  geo = geo
)
```

Arrange table

``` r
table <- geo_map

table_arr <- calculate_count_with_geo_oid(
  table = table
)
```

### Step 02. Adjustment

Adjusting for age and sex

``` r
table <- table_arr
mode <- "std" # "std" or "crd"
fraction <- "100000"
conf_level <- "0.95"

table_adj <- calculate_adjust_age_sex_indirectly(
  table = table,
  mode = mode,
  fraction = fraction,
  conf_level = conf_level
)
```

### Step 03-1. Calculate disease map

Generate graph file from geo data

``` r
geo <- geo

graph_file_path <- trans_geo_to_graph(
  geo = geo
)
```

Calculate disease map

``` r
table <- table_adj
graph_file_path <- graph_file_path

deriv <- calculate_disease_map(
  table = table,
  graph_file_path = graph_file_path
)
```

### Step 03-2. Calculate disease cluster

Calculate disease cluster

``` r
table <- table_adj

deriv <- calculate_disease_cluster(
  table = table
)
```

### Step 04. Plot

Merge geo data with derivatives

``` r
geo <- geo
deriv <- deriv$arranged_table

data <- merge_geo_with_deriv(
  geo = geo,
  deriv = deriv
)
```

Plot with data

``` r
data <- data
stats <- deriv$stats
color_type <- "colorQuantile"
color_param <- base::list(
  palette <- "Reds",
  domain <- NULL,
  bins <- 7,
  pretty <- TRUE,
  n <- 4,
  levels <- NULL,
  ordered <- FALSE,
  na.color <- "#FFFFFF",
  alpha <- FALSE,
  reverse <- FALSE,
  right <- FALSE,
)

plot <- get_leaflet_map(
  data = data,
  stats = stats,
  color_type = color_type,
  color_param = color_param
)
plot
```
