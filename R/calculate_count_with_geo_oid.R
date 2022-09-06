calculate_count_with_geo_oid <- function(input,
                                     ...) {
  table <- input$table

  # table <- stats::aggregate(
  #   cbind(
  #     target_count, outcome_count
  #   ) ~ oid, age_category, sex_category,
  #   data = table,
  #   FUN = base::sum
  # )
  table <- stats::aggregate(
    cbind(
      zip, location_id
    ) ~ oid + oname,
    data = table,
    FUN = base::sum
  )

  stats::aggregate(
    cbind(
      zip, location_id
    ) ~ oid + oname,
    data = table,
    FUN = base::sum
  )

  table
}

# calculate_count_with_geo_oid(input)
# table <- calculate_count_with_geo_oid(input)
