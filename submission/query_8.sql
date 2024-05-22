/*------------------------------------------------------------------
write a query to incrementally populate the host_activity_reduced 
table from a daily_web_metrics table.
*/------------------------------------------------------------------

INSERT INTO ykshon52797255.host_activity_reduced

-- only grab yesterday's data
WITH
  yesterday AS (
    SELECT
      *
    FROM
      ykshon52797255.host_activity_reduced
    WHERE
      month_start = '2023-08-01'
  ),
-- only grab today's data
  today AS (
    SELECT
      *
    FROM
      ykshon52797255.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')
  )

-- full outer join yesterday and today's date and cumulate for that  month
SELECT
  COALESCE(t.host, y.host) AS host,
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
  FULL OUTER JOIN yesterday y ON t.host = y.host
  AND t.metric_name = y.metric_name
