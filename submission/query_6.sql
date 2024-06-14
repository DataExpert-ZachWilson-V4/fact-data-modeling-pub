-- ## Host Activity Datelist Implementation (`query_6.sql`)

-- As shown in the fact data modeling day 2 lab, Write a query to incrementally populate the `hosts_cumulated` table from the `web_events` table.


INSERT INTO rgindallas.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      rgindallas.hosts_cumulated
    WHERE
      DATE = DATE('2023-07-11')
  ),
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events we
    LEFT JOIN
      bootcamp.devices d ON we.device_id = d.device_id
    WHERE
      date_trunc('day', event_time) = DATE('2023-07-12')
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-07-12') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
