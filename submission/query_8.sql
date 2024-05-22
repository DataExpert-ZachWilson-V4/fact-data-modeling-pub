INSERT INTO denzelbrown.host_activity_reduced
WITH
  former_data AS (
    SELECT * FROM denzelbrown.host_activity_reduced
    WHERE month_start = '2023-06-01'
  ),
  current_day AS (
    SELECT * FROM denzelbrown.daily_web_metrics 
    WHERE DATE = DATE('2023-06-02')
  )
SELECT
  COALESCE(cd.host, od.host) AS host,
  COALESCE(cd.metric_name, od.metric_name) AS metric_name,
  COALESCE(od.metric_array,REPEAT(NULL,CAST(DATE_DIFF('day', DATE('2023-06-01'), cd.date) AS INTEGER))) || ARRAY[cd.metric_value] AS metric_array,
  '2023-06-01' AS month_start
FROM
  former_data od FULL OUTER JOIN current_day cd ON cd.host = od.host
  AND cd.metric_name = od.metric_name
