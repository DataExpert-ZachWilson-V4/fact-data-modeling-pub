insert into deeptianievarghese22866.hosts_cumulated 
WITH
  yesterday AS (
    SELECT
      *
      from deeptianievarghese22866.hosts_cumulated 
      where date=date('2023-01-09')
  ),
  today AS (
     SELECT
      cast(user_id as varchar) as host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events 
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-10')
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-10') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host






