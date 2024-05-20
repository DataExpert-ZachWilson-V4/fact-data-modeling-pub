--HW2 query_6
INSERT INTO hdamerla.hosts_cumulated
WITH yesterday AS (
  SELECT * FROM hdamerla.hosts_cumulated 
  WHERE date = DATE('2023-01-05')
),
today AS (
  SELECT 
    host, 
    CAST(date_trunc('day', event_time) as DATE) as host_activity_datelist, 
    COUNT(1) 
  FROM bootcamp.web_events 
  WHERE date_trunc('day', event_time) = DATE('2023-01-06')
  GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
)
  
SELECT
COALESCE(y.host, t.host) as host,
CASE when y.host_activity_datelist is NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
ELSE ARRAY[t.host_activity_datelist]
END as host_activity_datelist,
CAST('2023-01-06' as DATE) as date
from yesterday y
full outer join today t
on y.host = t.host
