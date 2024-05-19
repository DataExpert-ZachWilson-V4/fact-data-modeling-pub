INSERT INTO ovoxo.host_activity_reduced
WITH
  previous_day AS (
    SELECT *
    FROM ovoxo.host_activity_reduced
    WHERE month_start = '2023-01-01'
  ),
  
  current_day AS (
    SELECT *
    FROM ovoxo.daily_web_metrics
    WHERE date = DATE('2023-01-01')
  )
  
SELECT COALESCE(c.host, p.host) AS host,
  COALESCE(c.metric_name, p.metric_name) AS metric_name,
  COALESCE(
    p.metric_array,
    REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2023-01-01'), c.date) AS INTEGER)) -- if no record from previous day, but exists in current day, construct metric array to account for all days from month start to current date and populate with nulls
    ) || ARRAY[c.metric_value] AS metric_array,
  '2023-01-01' AS month_start
FROM previous_day p
FULL OUTER JOIN current_day c 
  ON c.host = p.host 
  AND c.metric_name = p.metric_name