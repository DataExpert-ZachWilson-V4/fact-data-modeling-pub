-- Insert the results of the query into the host_activity_reduced table
INSERT INTO
  RaviT.host_activity_reduced
-- Common Table Expression (CTE) to get data for the specified month start date
WITH
  yesterday AS (
    SELECT
      * -- Select all columns from host_activity_reduced
    FROM
      RaviT.host_activity_reduced 
    WHERE
      month_start = '2023-08-01' -- Filter for the specific month start date
  ),
  -- CTE to get today's web metrics
  today AS (
    SELECT
      * -- Select all columns from daily_web_metrics
    FROM
      RaviT.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-03') -- Filter for the specific date
  )
-- Select combined results from the CTEs
SELECT
  COALESCE(t.host, y.host) AS host, -- Use the host from 'today' if it exists, otherwise use the host from 'yesterday'
  COALESCE(t.metric_name, y.metric_name) AS metric_name, -- Use the metric_name from 'today' if it exists, otherwise use the metric_name from 'yesterday'
  COALESCE(
    y.metric_array, -- If 'yesterday's metric_array exists, use it
    REPEAT(
      NULL, -- Otherwise, repeat NULL
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER -- Repeat NULL for the number of days between the month start and today's date
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array, -- Concatenate the metric_array with today's metric value
  '2023-08-01' AS month_start
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host = y.host -- Full outer join on host
  AND t.metric_name = y.metric_name; -- Join on metric_name
