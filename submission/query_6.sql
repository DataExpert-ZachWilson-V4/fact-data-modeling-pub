INSERT INTO dataste0.hosts_cumulated
WITH yesterday AS (
  SELECT *
  FROM dataste0.hosts_cumulated
  WHERE date = DATE('2022-12-31')
),

today AS (
  SELECT host, CAST(event_time AS DATE) AS event_date
  FROM bootcamp.web_events
  WHERE CAST(event_time AS DATE) = DATE('2023-01-01')
  GROUP BY host, CAST(event_time AS DATE)
)

SELECT 
  COALESCE(y.host,t.host) as host,
  CASE WHEN y.host_activity_datelist IS NOT NULL 
		THEN ARRAY[t.event_date] || y.host_activity_datelist
		ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date
FROM yesterday y 
FULL OUTER JOIN today t ON y.host=t.host
