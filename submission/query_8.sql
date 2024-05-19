INSERT INTO meetapandit89096646.host_activity_reduced
-- incremental query to load hosts activity reduced in a array date list
WITH yesterday AS (
    -- previous day snapshot
  SELECT *
  FROM meetapandit89096646.host_activity_reduced
  WHERE month_start = '2023-08-01'
  
)
-- current day's records aggregated daily web metrics table
, today AS (
  SELECT *
  FROM meetapandit89096646.daily_web_metrics
  WHERE date = DATE('2023-08-04')

)

-- full outer join yesterday's snapshot from hosts_activity_reduced and 
-- current day's records from daily aggregated metrics 
SELECT COALESCE(y.host, t.host) AS host
     , COALESCE(y.metric_name, t.metric_name) AS metric_name
     -- fill missing dates when there was no activity to align the arrays by day
     , COALESCE(y.metric_array, REPEAT(null, CAST(DATE_DIFF('day', DATE('2023-08-01'), date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array
     -- static snapshot date for given month start
     , '2023-08-01' AS month_start
FROM yesterday y
FULL OUTER JOIN today t ON y.host = t.host
                       AND y.metric_name = t.metric_name
 