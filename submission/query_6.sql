INSERT INTO
  nikhilsahni.hosts_cumulated
/*
  This Common Table Expression (CTE) named yesterday selects the host, host_activity_datelist, and DATE columns 
  from the nikhilsahni.hosts_cumulated table for a specific date. This CTE represents the state of the 
  hosts' activity up to the day before the new data.
*/
WITH
  yesterday AS (
    SELECT
      host,
      host_activity_datelist,
      DATE
    FROM
      nikhilsahni.hosts_cumulated
    WHERE
      DATE = DATE_ADD('day', -1 , CURRENT_DATE)
  ),
  /*
  This CTE named today, selects host and truncates the event_time to the day level as event_date.
  Filters the bootcamp.web_events table to include only events that occurred today.
  Groups the results by host and event_date, counting the number of events for each host. 
  This is being done to avoid duplicates
  */
  today AS (
    SELECT
      host,
      DATE(DATE_TRUNC('day', event_time)) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events
    WHERE
      DATE(DATE_TRUNC('day', event_time)) = CURRENT_DATE
      AND event_time IS NOT NULL
    GROUP BY
      host,
      DATE(DATE_TRUNC('day', event_time))
  )
/*
  This part of the query combines the yesterday and today CTEs using a full outer join on host to 
  ensure that all hosts from both CTEs are included in the result.
  COALESCE(y.host, t.host) AS host: Uses COALESCE to prefer the non-null value between y.host and t.host, 
  ensuring that the result contains a host value.
  CASE statement:
    If y.host is NULL, it means the host did not exist yesterday, so it initializes 
    the host_activity_datelist with the event_date from today.
    If both y.host and t.host are not NULL, it appends the event_date from today to the existing 
    host_activity_datelist from yesterday.
    If y.host is not NULL and t.host is NULL, it means the host had activity before but no activity today, 
    so it keeps the existing host_activity_datelist.
*/

SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host IS NULL THEN ARRAY[t.event_date]
    WHEN y.host IS NOT NULL
    AND t.host IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    WHEN y.host IS NOT NULL
    AND t.host IS NULL THEN y.host_activity_datelist
  END AS host_activity_datelist,
  CURRENT_DATE AS DATE
FROM
  yesterday AS y
  FULL OUTER JOIN today AS t ON y.host = t.host
