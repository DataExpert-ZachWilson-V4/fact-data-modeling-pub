--Host Activity Datelist Implementation 
-- Similar implementation to that of query_3

insert into hariomnayani88482.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      hariomnayani88482.hosts_cumulated
    WHERE
      DATE = date('2022-01-02')
  ),
  today AS (
    SELECT
      host,
      cast(date_trunc('day', event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = date('2023-01-03')
    GROUP BY
      host,
      date_trunc('day', event_time)
  )
SELECT
  coalesce(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  date('2023-01-03') AS DATE
FROM
  yesterday AS y
  FULL OUTER JOIN today AS t ON y.host = t.host