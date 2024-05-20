INSERT INTO bgar.host_activity_reduced
WITH yesterday AS (
SELECT * 
FROM bgar.host_activity_reduced
WHERE month_start = '2023-08-01'
),
today AS (
  SELECT *
  FROM bgar.daily_web_metrics
  WHERE date = '2023-08-01'
)
SELECT
  COALESCE(t.user_id, y.user_id) as user_id,
  COALESCE(t.metric_name, y.metric_name) as metric_name,
  COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', '2023-08-01', t.date) AS INTEGER))) || ARRAY[t.metric_value] as metric_array,
  '2023-08-01' as month_start
FROM today t 
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id
AND t.metric_name = y.metric_name
