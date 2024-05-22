-- Incrementally populate the host_activity_reduced table from the daily_web_metrics table
WITH
  -- Retrieve existing monthly metrics from the host_activity_reduced table for the previous month
  yesterday AS (
    SELECT
      host,
      metric_name,
      metric_array,
      month_start
    FROM
      raniasalzahrani.host_activity_reduced
    WHERE
      month_start = '2022-01-01'
  ),
  -- Fetch current day activity from the daily_web_metrics table for the current month
  today AS (
    SELECT
      host,
      metric_name,
      metric_value,
      DATE_FORMAT(DATE, '%Y-%m') AS month_start
    FROM
      raniasalzahrani.daily_web_metrics
    WHERE
      DATE_FORMAT(DATE, '%Y-%m') = '2022-01'
  )
  -- Combine the data from the previous and current month
SELECT
  COALESCE(y.host, t.host) AS host, -- Use host from today if available, otherwise from yesterday
  COALESCE(y.metric_name, t.metric_name) AS metric_name, -- Use metric_name from today if available, otherwise from yesterday
  -- Update metric_array by adding today's metric_value to the existing array if it exists
  CASE
    WHEN y.metric_array IS NOT NULL THEN y.metric_array || ARRAY[t.metric_value]
    ELSE ARRAY[t.metric_value]
  END AS metric_array,
  '2022-01-01' AS month_start -- Set the month_start to the beginning of the current month
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
  AND y.metric_name = t.metric_name
