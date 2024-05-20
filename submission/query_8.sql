-- Incrementally load ovoxo.host_activity_reduced from daily_web_metrics. 
-- daily_web_metrics does not exists but I created a ovoxo.daily_web_metrics_host which contains the required data.
--  so we will make the query 'runable' using a CTE for daily_web_metrics based on ovoxo.daily_web_metrics_host

INSERT INTO host_activity_reduced
WITH
  -- select data from ovoxo.daily_web_metrics_host to mimic daily_web_metrics
  daily_web_metrics AS (
    SELECT *
    FROM ovoxo.daily_web_metrics_host
  ),

  -- get previous day data for host if it exists
  previous_day AS (
    SELECT *
    FROM ovoxo.host_activity_reduced
    WHERE month_start = '2023-01-01'
  ),
  
  -- get current day data for host to be combine with exisiting data
  current_day AS (
    SELECT *
    FROM daily_web_metrics
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