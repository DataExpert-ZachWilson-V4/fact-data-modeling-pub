INSERT INTO jb19881.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      jb19881.hosts_cumulated
    WHERE
      DATE = DATE('2023-01-06')
  ),
  -- select user_id, device_id, referrer, host, url, event_time from bootcamp.web_events limit 100
  -- select device_id, browser_type, os_type, device_type from bootcamp.devices limit 100
  today AS (
    SELECT
      we.host,
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events we
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-07')
    GROUP BY
      we.host,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
SELECT
  COALESCE(y.host, t.host) AS user_id,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-07') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host