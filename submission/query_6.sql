Insert into 
  jrsarrat.hosts_cumulated 
--updated query an additional 6x to insert the following dates into CTE 'yesterday': 01-02, 01-03, 01-04, 01-05, 01-06, and 01-07.
WITH
  yesterday AS (
    SELECT
      *
    FROM
      jrsarrat.hosts_cumulated
    WHERE
      date = DATE('2023-01-01')
  ),
  today AS (
    SELECT
      we.host,
      CAST(date_trunc('day', we.event_time) AS DATE) AS host_activity_datelist,
      COUNT(1)
    FROM
      bootcamp.web_events we
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-02')
    GROUP BY
      we.host,
      CAST(date_trunc('day', event_time) AS date)
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
    ELSE ARRAY[t.host_activity_datelist]
END AS host_activity_datelist,
  date('2023-01-02') AS date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
