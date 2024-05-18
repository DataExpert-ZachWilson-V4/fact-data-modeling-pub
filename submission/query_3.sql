--Insert into
--jrsarrat.user_devices_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      jrsarrat.user_devices_cumulated
    WHERE
      date = DATE('2023-01-01')
  ),
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) AS dates_active,
      COUNT(1)
    FROM
      bootcamp.devices d
        join
          bootcamp.web_events we
            on we.device_id = d.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-02')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', event_time) AS date)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.dates_active] || y.dates_active
    ELSE ARRAY[t.dates_active]
END AS dates_active,
  date('2023-01-02') AS date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id
