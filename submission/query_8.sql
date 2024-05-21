INSERT INTO mmarquez225.host_activity_reduced
WITH yesterday AS (
  SELECT *
  FROM mmarquez225.host_activity_reduced
  WHERE month_start = '2023-08-01'
),
today AS(
  SELECT *
  FROM mmarquez225.daily_web_metrics 
  WHERE date = DATE('2023-08-02')
)
SELECT
  COALESCE(T.host, Y.host) AS host,
  COALESCE(T.metric_name, Y.metric_name) AS metric_name,
  COALESCE(
    Y.metric_array,
    REPEAT(null,
      CAST(DATE_DIFF('day', DATE('2023-08-01'), T.date) AS INTEGER)
    )) || ARRAY[T.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM today AS T
FULL OUTER JOIN yesterday AS Y 
  ON T.host = Y.host AND T.metric_name = Y.metric_name
  -- Outter join with host and metric_name as keys.