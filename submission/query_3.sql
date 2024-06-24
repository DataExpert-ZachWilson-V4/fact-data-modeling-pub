INSERT INTO jb19881.user_devices_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      jb19881.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-06')
  ),
  -- select user_id, device_id, referrer, host, url, event_time from bootcamp.web_events limit 100
  -- select device_id, browser_type, os_type, device_type from bootcamp.devices limit 100
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events we
      JOIN bootcamp.devices d
      ON we.device_id = d.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-07')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) as browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-07') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id