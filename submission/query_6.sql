/* Host Activity Datelist Implementation (query_6.sql)

As shown in the fact data modeling day 2 lab, Write a query to incrementally 
populate the hosts_cumulated table from the web_events table.
*/
INSERT INTO danieldavid.hosts_cumulated
-- 1) Start: pull hosts_cumulated from yesterday to use as a starting point
WITH yesterday AS (
  SELECT *
  FROM danieldavid.hosts_cumulated
  WHERE date = DATE('2023-01-01')
),
-- 2) Stage: clean today's data from web_events to match target hosts_cumulated schema
today AS (
    SELECT
        host,
        CAST(DATE_TRUNC('day',event_time) AS DATE) AS event_date
    FROM bootcamp.web_events
    WHERE DATE_TRUNC('day',event_time) = DATE('2023-01-02')
    GROUP BY 1,2
)
-- 2) Cumulate: if yesterday's host_activity_datelist is not null, append today's event_date to the first index 
-- else, create a new array with today's event_date
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE WHEN y.host_activity_datelist IS NOT NULL
            THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-02') AS date
FROM 
    yesterday y
    FULL OUTER JOIN today t 
    ON y.host = t.host
    -- Go go chatgpt feedback! :)