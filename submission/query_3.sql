INSERT INTO datademonslayer.user_devices_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      datademonslayer.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31')
  ),
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events AS we
JOIN bootcamp.devices AS d
ON we.device_id = d.device_id 
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-01')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type