INSERT INTO bgar.user_devices_cumulated
WITH web_events_and_devices AS (  
SELECT
    we.user_id,
    we.device_id,
    d.browser_type,
    we.referrer,
    we.host,
    we.host,
    we.event_time
FROM bootcamp.web_events we
LEFT JOIN bootcamp.devices d ON we.device_id = d.device_id
),
yesterday AS (
SELECT *
FROM bgar.user_devices_cumulated
WHERE date = DATE('2022-12-31')
),
today AS (
SELECT
    user_id,
    browser_type,
    CAST(date_trunc('day', event_time) as  DATE) as event_date,
    COUNT(1)
FROM web_events_and_devices
WHERE date_trunc('day', event_time) = DATE('2023-01-01')
GROUP BY user_id, browser_type, CAST(date_trunc('day', event_time) as DATE)
)
SELECT
  COALESCE(y.user_id, t.user_id) as user_id,
  COALESCE(y.browser_type, t.browser_type) as browser_type,
  CASE WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
  ELSE ARRAY[t.event_date]
  END as dates_active,
  DATE('2023-01-01') as date
FROM yesterday y 
FULL OUTER JOIN today t 
ON y.user_id = t.user_id
