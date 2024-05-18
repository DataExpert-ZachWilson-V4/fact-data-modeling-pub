--Insert one day's worth of data into the monthly host_activity_reduced table for the given month
--In practice this query would either need to be run as an INSERT OVERWRITE (which is not currently supported in Trino), or 
--would need to be followed by the following DELETE query
-- delete from monthly_array_web_metrics
-- where cardinality(metric_array) < 2	--Here 2 is the number of days currently represented in the table (date_diff from start of month to last day entered)
INSERT INTO host_activity_reduced
--In practice, daily_web_metrics would be another table loaded by a statement similar to the one below
WITH daily_web_metrics AS (
SELECT host,
  CASE WHEN url = '/' THEN 'visited_home_page'
     WHEN url = '/signup' THEN 'visited_signup' END AS metric_name,
  COUNT(CASE WHEN url IN ('/','/signup') THEN 1 END) AS metric_value,
  CAST(event_time AS DATE) AS date
FROM bootcamp.web_events
GROUP BY host,
  CASE WHEN url = '/' THEN 'visited_home_page'
     WHEN url = '/signup' THEN 'visited_signup' END,
  CAST(event_time AS DATE)
),
yesterday AS (
  SELECT *
  FROM host_activity_reduced
  WHERE month_start = '2023-08-01'
), 
today AS (
  SELECT *
  FROM daily_web_metrics
  WHERE date = DATE('2023-08-02')
	AND metric_name IS NOT NULL
)
SELECT COALESCE(t.host,y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  --Add today's value to right of array, create array of NULLs if this is the first occurrence of the metric in the month
  COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('DAY', DATE('2023-08-01'), t.date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM today t
  FULL OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name