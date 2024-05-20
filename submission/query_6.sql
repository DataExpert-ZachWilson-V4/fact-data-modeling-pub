-- Host Activity Datelist Implementation (query_6.sql)
-- This query incrementally populates the hosts_cumulated table from the web_events table.

INSERT INTO alissabdeltoro.hosts_cumulated
    
-- Step 1: Define the yesterday CTE to capture the state of hosts_cumulated table for the previous day.
WITH yesterday AS (
    SELECT * 
    FROM alissabdeltoro.hosts_cumulated
    WHERE date = DATE '2022-12-31'
),

-- Step 2: Define the today CTE to capture events from the web_events table for the current day.
today AS (
    SELECT 
        host,
        CAST(date_trunc('day', event_time) AS DATE) AS event_date,
        COUNT(1)
    FROM bootcamp.web_events
    WHERE date_trunc('day', event_time) = DATE '2023-01-01'
    GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
)

-- Step 3: Insert into the hosts_cumulated table by merging yesterday's data with today's data.
SELECT 
    COALESCE(y.host, t.host) AS host,
    -- Update the host_activity_datelist array by adding today's event_date to the front of the list.
    CASE 
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    -- Set the date to today's date.
    DATE '2023-01-01' AS date
FROM yesterday y
FULL OUTER JOIN today t 
ON y.host = t.host
