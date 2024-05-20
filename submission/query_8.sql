INSERT INTO
	host_activity_reduced
-- Get the previous day's data
WITH
  yesterday AS (
    SELECT
      *
    FROM
      host_activity_reduced
    WHERE
      month_start = '2023-08-01'
  ),
-- Get today's data drom the daily_web_metrics table
  today AS (
    SELECT
      *
    FROM
      bootcamp.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')
  )
SELECT
  COALESCE(t.host, y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  -- Make a normalized and equi-length array of the metric values across 'n' days
  COALESCE(
    -- In case there's no data for the next day or the previous day pick either to concat
    -- or start with an empty array
    y.metric_array,
    -- Ensure the array is of the same length for each array
    REPEAT(
      NULL,
      -- Repeat the null value for the difference in days between 
      -- the start date and the current date
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host = y.host
  AND t.metric_name = y.metric_name