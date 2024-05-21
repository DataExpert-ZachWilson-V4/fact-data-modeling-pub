/*
Host Activity Datelist Implementation (query_6.sql)
As shown in the fact data modeling day 2 lab, Write a query to incrementally populate the hosts_cumulated table from the web_events table.

Note: Remember to leverage a full outer join, and to properly handle imputing empty values in the array for windows where a host gets a visit in the middle of the array time window.
*/


INSERT INTO harathi.hosts_cumulated
-- Subquery for 'yesterday' data
WITH yesterday AS (
  SELECT
    host,
    host_activity_datelist
  FROM harathi.hosts_cumulated
  WHERE date = DATE('2022-12-31')
),

-- Subquery for 'today' data
today AS (
  SELECT  
    host,  
    CAST(date_trunc('day', event_time) AS DATE) AS event_date,  
    COUNT(*) AS event_count
  FROM bootcamp.web_events 
  WHERE date_trunc('day', event_time) = DATE('2023-01-01')
  GROUP BY 
    host,
    CAST(date_trunc('day', event_time) AS DATE)
)

-- Main query combining 'yesterday' and 'today' data
SELECT 
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date 
FROM yesterday y
FULL OUTER JOIN today t 
  ON y.host = t.host
