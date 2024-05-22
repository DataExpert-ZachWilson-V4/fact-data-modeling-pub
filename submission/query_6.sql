INSERT INTO
  emmaisemma.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      emmaisemma.hosts_cumulated
    WHERE
      DATE = DATE('2023-01-05')
  ),
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS host_activity_datelist,
      COUNT(1)
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-06')
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
    ELSE ARRAY[t.host_activity_datelist]
  END AS dates_active,
  DATE('2023-01-06') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host