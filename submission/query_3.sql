INSERT INTO user_devices_cumulated
WITH yesterday AS (
  SELECT *
  FROM user_devices_cumulated
  WHERE date = DATE('2022-09-30')
), 
today AS (
  SELECT we.user_id,
    d.browser_type,
    CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date
  FROM bootcamp.web_events we
    JOIN bootcamp.devices d ON we.device_id = d.device_id
  WHERE DATE_TRUNC('day', we.event_time) = DATE('2022-10-01')
  GROUP BY we.user_id,
    d.browser_type,
    DATE_TRUNC('day', we.event_time)
)
SELECT COALESCE(y.user_id,t.user_id) as user_id,
  COALESCE(y.browser_type,t.browser_type) as browser_type,
  CASE WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active ELSE ARRAY[t.event_date] END AS dates_active,
  DATE('2022-10-01') AS date
FROM yesterday y
  FULL OUTER JOIN today t on y.user_id = t.user_id
    AND y.browser_type = t.browser_type

