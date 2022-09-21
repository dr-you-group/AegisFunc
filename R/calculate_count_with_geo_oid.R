calculate_count_with_geo_oid <- function(input,
                                         ...) {
  table <- input$table

  table$target_count[is.na(table$target_count)] <- 0
  table$outcome_count[is.na(table$outcome_count)] <- 0

  table <- stats::aggregate(
    cbind(
      target_count, outcome_count
    ) ~ oid + latitude + longitude + age_category + sex_category,
    data = table,
    FUN = base::sum
  )

  table
}

# calculate_count_with_geo_oid(input)
# table <- calculate_count_with_geo_oid(input)
