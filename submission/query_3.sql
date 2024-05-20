INSERT INTO user_devices_cumulated WITH yesterday AS (
    SELECT *
    FROM user_devices_cumulated
    WHERE DATE = DATE('2022-12-31') - INTERVAL '1' DAY
  ),
  today AS (
    SELECT w.user_id,
      CAST(date_trunc('day', w.event_time) AS DATE) AS event_date,
      d.browser_type,
      COUNT(1)
    FROM bootcamp.web_events as w
      JOIN bootcamp.devices as d
      ON w.device_id = d.device_id
    WHERE date_trunc('day', w.event_time) = DATE('2023-01-01')
    GROUP BY user_id,
      CAST(date_trunc('day', w.event_time) AS DATE),
      d.browser_type
  )
SELECT COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) as browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY [t.event_date] || y.dates_active
    ELSE ARRAY [t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS DATE
FROM yesterday y
  FULL OUTER JOIN today t
  ON y.user_id = t.user_id
  AND y.browser_type = t.browser_type