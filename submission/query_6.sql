/*-----------------------------------------------------------------
Write a query to incrementally populate the hosts_cumulated table 
from the web_events table.
*/-----------------------------------------------------------------

insert into ykshon52797255.hosts_cumulated

-- only grab yesterday's data
WITH
  yesterday AS (
    SELECT
      *
    FROM
      ykshon52797255.hosts_cumulated
    WHERE
      DATE = DATE('2023-01-06')
  ),

  --only grab today's data
  today AS (
    SELECT
      host,
      -- only grab the date from event_time's timestamp
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-07')
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )

-- full outer join yesterday and today's data
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
