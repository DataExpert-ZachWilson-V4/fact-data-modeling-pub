INSERT INTO ebrunt.host_activity_reduced
WITH daily_web_metrics AS (
  SELECT
  host,
  'visited_sign_up' AS metric_name,
  COUNT(
    CASE
      WHEN url = '/signup' THEN 1
    END
  ) AS metric_value,
  CAST(event_time AS DATE) AS metric_date
FROM
  bootcamp.web_events
GROUP BY
  host,
  CAST(event_time AS DATE)
UNION 
  SELECT
  host,
  'visited_home_page' AS metric_name,
  COUNT(
    CASE
      WHEN url = '/' THEN 1
    END
  ) AS metric_value,
  CAST(event_time AS DATE) AS metric_date
FROM
  bootcamp.web_events
GROUP BY
  host,
  CAST(event_time AS DATE)
),
yesterday AS (
  SELECT 
    * 
  FROM ebrunt.host_activity_reduced 
  WHERE DATE(month_start) = DATE('2021-04-01')
),
today AS (
  SELECT 
    * 
  FROM daily_web_metrics 
  WHERE metric_date = DATE('2021-04-02')
)
SELECT 
  COALESCE(y.host, t.host) as host,
  COALESCE(y.metric_name, t.metric_name) as metric_name,
  COALESCE(y.metric_array, REPEAT(null, CAST(DATE_DIFF('day', DATE('2021-04-02'), t.metric_date) AS INTEGER))) || ARRAY[t.metric_value] as metric_array,
  DATE('2021-04-02') as month_start
FROM yesterday y
FULL OUTER JOIN today t ON t.host = y.host AND t.metric_name = y.metric_name
