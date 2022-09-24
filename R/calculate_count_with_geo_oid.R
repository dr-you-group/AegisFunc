#' Title
#'
#' @param input
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
calculate_count_with_geo_oid <- function(input,
                                         ...) {
  table <- input$table

  table$target_count[is.na(table$target_count)] <- 1
  table$outcome_count[is.na(table$outcome_count)] <- 0
  table$latitude[is.na(table$latitude)] <- table$lat[is.na(table$latitude)]
  table$longitude[is.na(table$longitude)] <- table$long[is.na(table$longitude)]
  table$age_category[is.na(table$age_category)] <- 0
  table$sex_category[is.na(table$sex_category)] <- 0

  table <- stats::aggregate(
    cbind(
      target_count, outcome_count
    ) ~ oid + latitude + longitude + age_category + sex_category,
    data = table,
    FUN = base::sum,
    na.action = na.pass
  )

  table
}

# calculate_count_with_geo_oid(input)
# table <- calculate_count_with_geo_oid(input)
