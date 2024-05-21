WITH
  -- Define a CTE named 'yesterday' to select all records from 'host_activity_reduced' where the month_start is '2023-01-01'
  yesterday AS (
    SELECT *
    FROM ningde95.host_activity_reduced
    WHERE month_start = '2023-01-01'
  ),

  -- Define a CTE named 'today' to aggregate daily metrics from 'daily_web_metrics' for the date '2023-01-03'
  today AS (
    SELECT
      host,
      metric_name,
      SUM(metric_value) AS metric_value,  -- Sum the metric values per host and metric name
      event_date
    FROM
      ningde95.daily_web_metrics
    WHERE
      event_date = DATE('2023-01-03')  -- Filter records for the specific date
    GROUP BY
      host, metric_name, event_date  -- Group by host, metric name, and event date to aggregate the metric values
  )

-- Final SELECT statement to combine 'yesterday' and 'today' data
SELECT
  COALESCE(t.host, y.host) AS host,  -- Combine 'host' from 'today' and 'yesterday', preferring non-null values
  COALESCE(t.metric_name, y.metric_name) AS metric_name,  -- Combine 'metric_name' from 'today' and 'yesterday', preferring non-null values
  COALESCE(
    y.metric_array,  -- Use 'metric_array' from 'yesterday' if it exists
    REPEAT(
      NULL,  -- If 'metric_array' is null, create an array of NULL values
      CAST(
        DATE_DIFF('day', DATE('2023-01-01'), t.event_date) AS INTEGER  -- Calculate the number of days between '2023-01-01' and 'event_date'
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,  -- Concatenate the existing 'metric_array' with the new 'metric_value' from 'today'
  '2023-01-01' AS month_start  -- Set 'month_start' to '2023-01-01' for all records
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host = y.host AND t.metric_name = y.metric_name  -- Perform a full outer join on 'today' and 'yesterday' using 'host' and 'metric_name'
