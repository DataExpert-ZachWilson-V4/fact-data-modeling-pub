--Host Activity Datelist Implementation (query_6.sql)
--As shown in the fact data modeling day 2 lab, Write a query to incrementally populate the hosts_cumulated table from the  --web_events table.

INSERT INTO saidaggupati.hosts_cumulated
WITH
  old_data AS (
    SELECT host,host_activity_datelist
    FROM saidaggupati.hosts_cumulated
    WHERE DATE = DATE '2022-10-27'
  ),
  current_data AS (
    SELECT host,CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM bootcamp.web_events
    WHERE date_trunc('day', event_time) = DATE '2022-10-28'
    GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
  ),
  combined AS (
    SELECT
      COALESCE(od.host, cd.host) AS host,
      CASE
        WHEN od.host_activity_datelist IS NOT NULL THEN ARRAY[cd.event_date] || od.host_activity_datelist
        ELSE ARRAY[cd.event_date]
      END AS host_activity_datelist,
      DATE '2022-10-28' AS date
    FROM
      old_data od
      FULL OUTER JOIN current_data cd ON od.host = cd.host
  )

SELECT host,host_activity_datelist,date
FROM combined