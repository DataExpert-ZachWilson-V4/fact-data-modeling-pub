INSERT INTO dataste0.user_devices_cumulated
WITH yesterday AS (
  SELECT *
  FROM dataste0.user_devices_cumulated
  WHERE date = DATE('2023-01-06')
),

today AS (
    SELECT w.user_id, d.browser_type, CAST(event_time AS DATE) AS event_date
  FROM bootcamp.web_events w
  LEFT JOIN bootcamp.devices d ON w.device_id=d.device_id
  WHERE CAST(event_time AS DATE) = DATE('2023-01-07')
  GROUP BY w.user_id, d.browser_type, CAST(event_time AS DATE)
)

SELECT 
  COALESCE(y.user_id,t.user_id) as user_id,
  COALESCE(y.browser_type,t.browser_type) as browser_type,
  CASE WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
  ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-07') AS date
FROM yesterday y 
FULL OUTER JOIN today t ON y.user_id=t.user_id AND y.browser_type=t.browser_type
