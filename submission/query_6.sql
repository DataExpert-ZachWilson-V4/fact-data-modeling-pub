-- query_6
INSERT INTO hosts_cumulated
WITH
  yesterday AS (
    SELECT *
      FROM hosts_cumulated
     WHERE date = DATE('2022-12-31')
  ),
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS host_activity_datelist
      FROM bootcamp.web_events
     WHERE date_trunc('day', event_time) = DATE('2023-01-01')
     GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
  )

SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
    ELSE ARRAY[t.host_activity_datelist]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date
  FROM yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
