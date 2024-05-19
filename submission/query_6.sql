INSERT INTO meetapandit89096646.hosts_cumulated
-- create an aggregated table from web_events by host name
WITH hosts_aggregated AS (
SELECT host
       -- cast event_time to date 
     , CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date
     -- get a count of hosts visted by day
     , COUNT(*) AS cnt
FROM bootcamp.web_events
GROUP BY host
       , CAST(DATE_TRUNC('day', event_time) AS DATE)
 )
 -- previous day snapshot for incremental load
 , yesterday AS (
    SELECT *
    FROM meetapandit89096646.hosts_cumulated
    WHERE date = DATE('2023-01-06')
 )
 -- current day from append to host_cumulated table
 , today AS (
    SELECT host
         , event_date
         , COUNT(*)
    FROM hosts_aggregated
    WHERE event_date = DATE('2023-01-07')
    GROUP BY host
            , event_date
 )

-- Merge yesterday and today using full ouetr join to account for all users irrespective when active
SELECT COALESCE(y.host, t.host) AS host
        -- if user is net new then create an array list with current dats as active
     , CASE WHEN y.host_activity_datelist IS NULL
           THEN ARRAY[t.event_date]
           -- if user already exists then join current day before previous day
         ELSE ARRAY[t.event_date] || y.host_activity_datelist
       END AS host_activity_datelist
       -- current day as snapshot day
     , DATE('2023-01-07') AS date
FROM yesterday y
FULL OUTER JOIN today t ON y.host = t.host
