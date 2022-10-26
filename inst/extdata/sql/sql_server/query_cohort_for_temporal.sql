SELECT DISTINCT
  c.cohort_definition_id,
  c.subject_id,
  c.cohort_start_date,
  c.cohort_end_date,
  p.location_id
FROM (SELECT * FROM @result_database_schema.cohort
WHERE
  cohort_definition_id = @outcome_cohort_definition_id or cohort_definition_id = @target_cohort_definition_id
) c left join (select person_id, location_id from @cdm_database_schema.person
) p
on c.subject_id = p.person_id