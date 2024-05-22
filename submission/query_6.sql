INSERT INTO ebrunt.hosts_cumulated
WITH yesterday AS (
  SELECT 
    * 
  FROM ebrunt.hosts_cumulated 
  WHERE date = DATE('2021-04-01')
),
today AS (
  SELECT 
    host, 
    CAST(DATE_TRUNC('day', event_time) AS DATE) as event_date, 
    count(*) as host_count 
  FROM bootcamp.web_events we
  WHERE CAST(DATE_TRUNC('day', event_time) AS DATE) = DATE('2021-04-02')
  GROUP BY 1,2
)
SELECT 
  COALESCE(y.host, t.host) as host,
  CASE
    WHEN y.host_activity_datelist IS NULL THEN ARRAY[t.event_date]
    WHEN t.event_date IS NULL THEN y. host_activity_datelist
    ELSE ARRAY[t.event_date] || y.host_activity_datelist
  END as host_activity_datelist,
  DATE('2021-04-02') as date
FROM yesterday y
FULL OUTER JOIN today t 
  ON t.host = y.host
