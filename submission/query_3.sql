INSERT INTO ykshon52797255.user_devices_cumulated

WITH
  yesterday AS (
    SELECT
      *
    FROM
      ykshon52797255.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-06')
  ),
  today AS (
    SELECT
      a.user_id,
      b.browser_type,
      CAST(date_trunc('day', a.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events a
    LEFT JOIN 
      bootcamp.devices b
    on a.device_id = b.device_id
    WHERE
      date_trunc('day', a.event_time) = DATE('2023-01-07')
    GROUP BY
      a.user_id,
      b.browser_type,
      CAST(date_trunc('day', a.event_time) AS DATE)
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
