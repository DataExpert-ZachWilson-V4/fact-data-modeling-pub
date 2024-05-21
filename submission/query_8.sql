--incrementally populate the host_activity_reduced
INSERT INTO vaishnaviaienampudi83291.host_activity_reduced
WITH
  yesterday AS ( -- get yesterday's data from host_activity_reduced table
    SELECT
      *
    FROM
      vaishnaviaienampudi83291.host_activity_reduced
    WHERE
      month_start = '2023-05-01'
  ),
  today AS ( -- get today's data from daily_web_metrics table
    SELECT
      *
    FROM
      vaishnaviaienampudi83291.daily_web_metrics 
    WHERE
      DATE = DATE('2023-05-02')
  )
SELECT
  COALESCE(t.host, y.host) AS host, --using coalesce function to avoid null values
  COALESCE(t.metric_name, y.metric_name) AS metric_name, -- name of the metric
  COALESCE(
    y.metric_array, 
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-05-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array, --if previous data already exists, we append the new data to the existing, if not create a new array
  '2023-05-01' AS month_start
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host = y.host --join yesterday's data with today's data on host and metric_name
  AND t.metric_name = y.metric_name
