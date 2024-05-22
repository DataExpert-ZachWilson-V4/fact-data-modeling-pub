INSERT INTO host_activity_reduced 
-- CTE to select records from host_activity_reduced for the previous month start date (2023-08-01)
WITH yesterday AS (
  SELECT *
  FROM host_activity_reduced
  WHERE month_start = '2023-08-01'
),
-- CTE to select daily web metrics for hosts for today's date
today AS (
  SELECT *
  FROM ibrahimsherif.daily_web_metrics_hosts
  WHERE date = DATE('2023-08-02')
)
-- Select and combine data from both CTEs
SELECT
  COALESCE(t.host, y.host) AS host,  -- Use host from today or yesterday
  COALESCE(t.metric_name, y.metric_name) AS metric_name,  -- Use metric_name from today or yesterday
  -- Combine metric arrays from yesterday with today's metric value
  COALESCE(
    y.metric_array,  -- Use yesterday's metric array if it exists
    REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER))  -- Otherwise, create an array with NULL values up to the current date
  ) || ARRAY[t.metric_value] AS metric_array,  -- Append today's metric value to the array
  '2023-08-01' AS month_start  -- Set the month start date to the current month start
FROM today t
FULL OUTER JOIN yesterday y 
  ON t.host = y.host AND t.metric_name = y.metric_name

-- Test the output table
-- SELECT *
-- FROM ibrahimsherif.host_activity_reduced
-- WHERE host = 'www.eczachly.com'
