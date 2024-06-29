INSERT INTO malmarzooq80856.host_activity_reduced 

WITH yesteday AS (
  SELECT *
  FROM malmarzooq80856.host_activity_reduced
  WHERE month_start = DATE '2022-12-01'
),
today AS (
  SELECT *
  FROM malmarzooq80856.daily_web_metrics_v2
  WHERE date = DATE '2022-12-02'
)
SELECT
  COALESCE(t.host, y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  COALESCE(
    y.metric_array, 
    REPEAT(null,
      CAST(DATE_DIFF('day', CAST(t.date AS DATE), y.month_start) AS INTEGER)
    )) || ARRAY[t.metric_value] AS metric_array,
  DATE '2022-12-02' AS month_start
FROM today t
FULL OUTER JOIN yesteday y 
  ON t.host = y.host AND t.metric_name = y.metric_name
