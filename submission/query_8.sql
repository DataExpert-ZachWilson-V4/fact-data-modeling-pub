INSERT INTO
  saismail.host_activity_reduced
WITH
  yesterday AS (
    SELECT
      host,
      metric_name,
      metric_array,
      month_start
    FROM
      saismail.host_activity_reduced
    WHERE
      month_start = '2021-01-01'
  ),
  today AS (
    SELECT
      host,
      metric_name,
      CAST(metric_value AS INTEGER) AS metric_value, -- Convert metric_value to INTEGER
      month_start
    FROM
      saismail.daily_web_metrics
    WHERE
      month_start = '2021-01-02'
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  COALESCE(y.metric_name, t.metric_name) AS metric_name,
  COALESCE(
    y.metric_array,
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE '2021-01-01', CAST(t.month_start AS  DATE)) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  '2021-01-01' AS month_start
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
  AND y.metric_name = t.metric_name