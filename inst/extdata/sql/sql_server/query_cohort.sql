WITH
target_cohort AS (
SELECT DISTINCT
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
FROM @result_database_schema.cohort
WHERE
  cohort_definition_id = @target_cohort_definition_id
AND
  CAST('@cohort_start_date' AS DATE) <= cohort_start_date
AND
  CAST('@cohort_start_date' AS DATE) >= cohort_end_date
),
outcome_cohort AS (
SELECT DISTINCT
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
FROM @result_database_schema.cohort
WHERE
  cohort_definition_id = @outcome_cohort_definition_id
),
including_cohort AS (
SELECT DISTINCT
  o.cohort_definition_id,
  o.subject_id,
  o.cohort_start_date,
  o.cohort_end_date
FROM outcome_cohort o
LEFT JOIN target_cohort t
ON
  t.subject_id = o.subject_id
AND
  t.cohort_start_date <= o.cohort_start_date
AND
  t.cohort_end_date >= o.cohort_start_date
AND
  DATEADD(day, CAST('@time_at_risk_start_date' AS INTEGER), t.cohort_start_date) <= o.cohort_start_date
AND
  DATEADD(day, CAST('@time_at_risk_end_date' AS INTEGER), t.@time_at_risk_end_date_panel) <= o.cohort_end_date
),
including_cohort_w_person AS (
SELECT
  c.cohort_definition_id,
  c.subject_id,
  c.cohort_start_date,
  c.cohort_end_date,
  p.location_id,
  CASE
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth >= 79 THEN 8
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 69 THEN 7
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 59 THEN 6
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 49 THEN 5
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 39 THEN 4
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 29 THEN 3
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 19 THEN 2
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth >= 10 THEN 1
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth <= 9 THEN 0
  END AS age_category,
  CASE
    WHEN p.gender_concept_id = '8507' THEN 0
    WHEN p.gender_concept_id = '8532' THEN 1
  END AS sex_category
FROM including_cohort c
INNER JOIN @cdm_database_schema.person p
ON
  c.subject_id = p.person_id
),
including_cohort_w_person_w_location AS (
SELECT
  c.subject_id,
  l.location_id,
  l.latitude,
  l.longitude,
  c.age_category,
  c.sex_category
FROM including_cohort_w_person c
INNER JOIN @cdm_database_schema.location l
ON
  c.location_id = l.location_id
),
all_in_target_cohort AS (
SELECT DISTINCT
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
FROM @result_database_schema.cohort
WHERE
  cohort_definition_id = @target_cohort_definition_id
),
all_in_target_cohort_w_person AS (
SELECT
  c.cohort_definition_id,
  c.subject_id,
  c.cohort_start_date,
  c.cohort_end_date,
  p.location_id,
  CASE
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth >= 79 THEN 8
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 69 THEN 7
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 59 THEN 6
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 49 THEN 5
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 39 THEN 4
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 29 THEN 3
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth > 19 THEN 2
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth >= 10 THEN 1
    WHEN YEAR(c.cohort_start_date) - p.year_of_birth <= 9 THEN 0
  END AS age_category,
  CASE
    WHEN p.gender_concept_id = '8507' THEN 0
    WHEN p.gender_concept_id = '8532' THEN 1
  END AS sex_category
FROM all_in_target_cohort c
LEFT JOIN @cdm_database_schema.person p
ON
  c.subject_id = p.person_id
)


SELECT
  t.location_id,
  t.latitude,
  t.longitude,
  t.age_category,
  t.sex_category,
  CAST(t.target_count AS INTEGER) AS target_count,
  CAST(o.outcome_count AS INTEGER) AS outcome_count
FROM
(
  SELECT
    l.location_id,
    l.latitude,
    l.longitude,
    c.age_category,
    c.sex_category,
    COUNT(c.subject_id) AS target_count
  FROM all_in_target_cohort_w_person c
  INNER JOIN @cdm_database_schema.location l
  ON
    c.location_id = l.location_id
  AND
    c.cohort_definition_id = @target_cohort_definition_id
  AND
    CAST('@cohort_start_date' AS DATE) <= c.cohort_start_date
  AND
    CAST('@cohort_end_date' AS DATE) >= c.cohort_end_date
  GROUP BY l.location_id, l.latitude, l.longitude, c.age_category, c.sex_category
) t
LEFT JOIN
(
  SELECT
    location_id,
    latitude,
    longitude,
    age_category,
    sex_category,
    COUNT(subject_id) AS outcome_count
  FROM including_cohort_w_person_w_location
  GROUP BY location_id, latitude, longitude, age_category, sex_category
) o
ON
  t.location_id = o.location_id
AND
  t.latitude = o.latitude
AND
  t.longitude = o.longitude
AND
  t.age_category = o.age_category
AND
  t.sex_category = o.sex_category
ORDER BY t.location_id, t.age_category, t.sex_category
;
