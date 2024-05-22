/*
The query inserts data into the nikhilsahni.host_activity_reduced table by combining daily metrics from 
nikhilsahni.daily_web_metrics and existing monthly metrics from nikhilsahni.host_activity_reduced. 
The goal is to update the monthly metrics with new daily data.
*/
INSERT INTO
  nikhilsahni.host_activity_reduced
/*
  This CTE gets all existing records from nikhilsahni.host_activity_reduced for the month starting 2023-08-01
*/
WITH
  yesterday AS (
    SELECT
      *
    FROM
      nikhilsahni.host_activity_reduced
    WHERE
      month_start = '2023-08-01'
  ),
  -- This CTE gets all daily metrics from nikhilsahni.daily_web_metrics
  today AS (
    SELECT
      *
    FROM
      nikhilsahni.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')
  )
/*
A full outer join combines today and yesterday on user_id and metric_name, ensuring all records are included 
even if there is no match. COALESCE selects values from today if they exist, otherwise from yesterday.
The metric_array is updated by either appending to the existing array from yesterday or creating a new array 
if none exists. If yesterday.metric_array does not exist, it creates an array with NULL values for each day 
from the start of the month up to the current day, filling gaps if necessary.
*/
SELECT
  COALESCE(t.user_id, y.user_id) AS user_id,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  COALESCE(
    y.metric_array,
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.user_id = y.user_id
  AND t.metric_name = y.metric_name
