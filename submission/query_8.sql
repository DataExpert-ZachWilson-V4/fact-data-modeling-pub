-- Insert the results into the host_activity_reduced table
INSERT INTO mmarquez225.host_activity_reduced (host, metric_name, metric_array, month_start)
WITH yesterday AS (
  -- Select all columns from the host_activity_reduced table for the specified month_start
  SELECT *
  FROM mmarquez225.host_activity_reduced
  WHERE month_start = '2023-08-01'
),
today AS (
  -- Select all columns from the daily_web_metrics table for the specified date
  SELECT *
  FROM mmarquez225.daily_web_metrics 
  WHERE date = DATE('2023-08-02')
)
SELECT
  -- Coalesce to handle missing hosts by taking non-null values
  COALESCE(T.host, Y.host) AS host,
  -- Coalesce to handle missing metric names by taking non-null values
  COALESCE(T.metric_name, Y.metric_name) AS metric_name,
  -- Coalesce to handle missing metric arrays by creating a padded array
  COALESCE(
    Y.metric_array,
    REPEAT(null, 
      CAST(DATE_DIFF('day', DATE('2023-08-01'), DATE('2023-08-02')) AS INTEGER)
    )
  ) || ARRAY[T.metric_value] AS metric_array,
  -- Set the month_start to '2023-08-01' as specified
  '2023-08-01' AS month_start
FROM today AS T
-- Perform a full outer join on host and metric_name to combine both CTEs
FULL OUTER JOIN yesterday AS Y 
  ON T.host = Y.host AND T.metric_name = Y.metric_name
