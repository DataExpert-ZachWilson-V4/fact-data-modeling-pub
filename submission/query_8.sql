/* Write a query to incrementally populate the host_activity_reduced table from a daily_web_metrics table */

INSERT INTO host_activity_reduced
-- CTE to retrieve existing data
WITH yesterday AS (
  SELECT 
    *
  FROM host_activity_reduced
  WHERE month_start = '2023-05-1'
),
-- CTE to retrieve incoming data from current date
today AS (
  SELECT 
    *
  FROM supreethkabbin.daily_web_metrics
  WHERE date = DATE('2023-05-22')
)
SELECT 
    COALESCE(y.host, t.host) AS host,
    COALESCE(y.metric_name, t.metric_name) AS metric_name,
    -- Extrapolate data for dates where activity is missing
    COALESCE(y.metric_array, REPEAT(null, CAST(DATE_DIFF('day', DATE('2023-05-1'), date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
    '2023-05-1' AS month_start
FROM yesterday y
FULL OUTER JOIN today t 
    ON y.host = t.host
    AND y.metric_name = t.metric_name