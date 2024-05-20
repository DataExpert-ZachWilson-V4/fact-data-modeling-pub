-- CUMULATED TABLE JOB will get loaded one day at a time
-- USING FULL OUTER JOIN to get data from both yesterday and today
-- LOAD host_activity_datelist (ARRAY) from date for host

INSERT INTO tharwaninitin.hosts_cumulated
WITH yesterday AS (
  SELECT *
  FROM tharwaninitin.hosts_cumulated
  WHERE date = DATE('2022-12-31')
),
today AS (
  SELECT we.host, CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date
  FROM bootcamp.web_events we
  JOIN bootcamp.devices d ON we.device_id = d.device_id
  WHERE CAST(DATE_TRUNC('day', we.event_time) AS DATE) = DATE('2023-01-01')
  GROUP BY we.host, CAST(DATE_TRUNC('day', we.event_time) AS DATE)
)
SELECT COALESCE(y.host,t.host) as host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date
FROM yesterday y
FULL OUTER JOIN today t on y.host = t.host