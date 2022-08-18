IF OBJECT_ID('tempdb..#TARGET_COHORT') IS NOT NULL
  DROP TABLE #TARGET_COHORT
IF OBJECT_ID('tempdb..#OUTCOME_COHORT') IS NOT NULL
  DROP TABLE #OUTCOME_COHORT
IF OBJECT_ID('tempdb..#INCLUDING_COHORT') IS NOT NULL
  DROP TABLE #INCLUDING_COHORT
IF OBJECT_ID('tempdb..#INCLUDING_COHORT_W_PERSON') IS NOT NULL
  DROP TABLE #INCLUDING_COHORT_W_PERSON
IF OBJECT_ID('tempdb..#INCLUDING_COHORT_W_PERSON_W_LOCATION') IS NOT NULL
  DROP TABLE #INCLUDING_COHORT_W_PERSON_W_LOCATION
IF OBJECT_ID('tempdb..#ALL_IN_TARGET_COHORT') IS NOT NULL
  DROP TABLE #ALL_IN_TARGET_COHORT
IF OBJECT_ID('tempdb..#ALL_IN_TARGET_COHORT_W_PERSON') IS NOT NULL
  DROP TABLE #ALL_IN_TARGET_COHORT_W_PERSON



SELECT DISTINCT
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
INTO #TARGET_COHORT
FROM @result_database_schema.COHORT
WHERE
  cohort_definition_id = @target_cohort_definition_id
AND
  '@cohort_start_date' <= cohort_start_date
AND
  '@cohort_end_date' >= cohort_end_date

SELECT DISTINCT
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
INTO #OUTCOME_COHORT
FROM @result_database_schema.COHORT
WHERE
  cohort_definition_id = @outcome_cohort_definition_id

SELECT DISTINCT
  o.cohort_definition_id,
  o.subject_id,
  o.cohort_start_date,
  o.cohort_end_date
INTO #INCLUDING_COHORT
FROM #OUTCOME_COHORT o
LEFT JOIN #TARGET_COHORT t
ON
  t.subject_id = o.subject_id
WHERE
  t.cohort_start_date <= o.cohort_start_date
AND
  t.cohort_end_date >= o.cohort_start_date
AND
  DATEADD(day, '@time_at_risk_start_date', t.cohort_start_date) <= o.cohort_start_date
AND
  DATEADD(day, '@time_at_risk_end_date', t.@time_at_risk_end_date_panel) <= o.cohort_end_date

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
  END AS age_category
  CASE
    WHEN p.gender_concept_id = '8507' THEN 0
    WHEN p.gender_concept_id = '8532' TEHN 1
  END AS sex_category
INTO #INCLUDING_COHORT_W_PERSON
FROM #INCLUDING_COHORT c
INNER JOIN @cdm_database_schema.PERSON p
ON
  c.subject_id = p.person_id

SELECT DISTINCT
  c.subject_id,
  l.location_id,
  l.latitude,
  l.longitude,
  c.age_category,
  c.sex_category
INTO #INCLUDING_COHORT_W_PERSON_W_LOCATION
FROM #INCLUDING_COHORT_W_PERSON c
INNER JOIN @cdm_database_schema.LOCATION l
ON
  c.location_id = l.location_id
ORDER BY 
  c.location_id


SELECT DISTINCT
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
INTO #ALL_IN_TARGET_COHORT
FROM @result_database_schema.COHORT
WHERE
  cohort_definition_id = @target_cohort_definition_id

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
  END AS age_category
  CASE
    WHEN p.gender_concept_id = '8507' THEN 0
    WHEN p.gender_concept_id = '8532' TEHN 1
  END AS sex_category
INTO #ALL_IN_TARGET_COHORT_W_PERSON
FROM ##ALL_IN_TARGET_COHORT c
LEFT JOIN @cdm_database_schema.PERSON p
ON
  c.subject_id = p.person_id


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
  FROM #ALL_IN_TARGET_COHORT_W_PERSON c
  INNER JOIN @cdm_database_schema.LOCATION l
  WHERE
    c.cohort_definition_id = @target_cohort_definition_id
  AND
    '@cohort_start_date' <= c.cohort_start_date
  AND
    '@cohort_end_date' >= c.cohort_end_date
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
  FROM #INCLUDING_COHORT_W_PERSON_W_LOCATION
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



DROP TABLE #TARGET_COHORT
DROP TABLE #OUTCOME_COHORT
DROP TABLE #INCLUDING_COHORT
DROP TABLE #INCLUDING_COHORT_W_PERSON
DROP TABLE #INCLUDING_COHORT_W_PERSON_W_LOCATION
DROP TABLE #ALL_IN_TARGET_COHORT
DROP TABLE #ALL_IN_TARGET_COHORT_W_PERSON
