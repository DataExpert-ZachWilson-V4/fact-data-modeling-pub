WITH
  yesterday AS (
    SELECT
      *
    FROM
      abhishekshetty.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-09')
  ),
  today AS (
    SELECT
      a.user_id,
      b.browser_type,
      CAST(date_trunc('day', a.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events a
      left join bootcamp.devices b on a.device_id = b.device_id
    WHERE
      date_trunc('day', a.event_time) = DATE('2023-01-10')
    GROUP BY
      a.user_id,
      b.browser_type,
      CAST(date_trunc('day', a.event_time) AS DATE)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-10') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id
