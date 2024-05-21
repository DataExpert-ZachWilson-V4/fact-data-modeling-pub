insert into abhishekshetty.hosts_cumulated
WITH yesterday AS (
  SELECT *
  FROM  abhishekshetty.hosts_cumulated
  WHERE date = DATE('2023-01-06')
  
),

today AS (
  SELECT host,
  CAST(date_trunc('day', event_time) AS DATE) AS event_date
  FROM bootcamp.web_events
  WHERE CAST(date_trunc('day', event_time) AS DATE) = DATE('2023-01-07')
  GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
)

SELECT 
  COALESCE(y.host,t.host) as host,
  CASE WHEN y.host_activity_datelist IS NOT NULL 
		THEN ARRAY[t.event_date] || y.host_activity_datelist
		ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-07') AS date
FROM yesterday y 
FULL OUTER JOIN today t ON y.host=t.host
