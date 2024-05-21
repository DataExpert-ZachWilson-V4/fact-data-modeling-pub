INSERT INTO ebrunt.user_devices_cumulated
WITH yesterday AS (
  SELECT 
    * 
  FROM ebrunt.user_devices_cumulated 
  WHERE date = DATE('2021-02-06')
),
today AS (
  SELECT 
    user_id, 
    browser_type, 
    CAST(DATE_TRUNC('day', event_time) AS DATE) as event_date, 
    count(*) as device_count 
  FROM bootcamp.web_events we
  JOIN bootcamp.devices d 
    ON d.device_id = we.device_id
  WHERE CAST(DATE_TRUNC('day', event_time) AS DATE) = DATE('2021-02-07')
  GROUP BY 1,2,3
)
SELECT 
  COALESCE(y.user_id, t.user_id) as user_id,
  COALESCE(y.browser_type, t.browser_type) as browser_type,
  CASE
    WHEN y.dates_active IS NULL THEN ARRAY[t.event_date]
    WHEN t.event_date IS NULL THEN y.dates_active
    ELSE ARRAY[t.event_date] || y.dates_active
  END as dates_active,
  DATE('2021-02-07') as date
FROM yesterday y
FULL OUTER JOIN today t 
  ON t.user_id = y.user_id 
  AND t.browser_type = y.browser_type
