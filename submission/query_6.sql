INSERT INTO
  derekleung.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      derekleung.hosts_cumulated
    WHERE
      DATE = DATE('2023-01-06')
  ),
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      derekleung.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-07')
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
        )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-07') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
