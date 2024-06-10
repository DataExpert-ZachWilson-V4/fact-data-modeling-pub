/*
As shown in the fact data modeling day 2 lab.
Write a query to incrementally populate the hosts_cumulated table from the web_events table.
*/

/*
As shown in the fact data modeling day 2 lab.
Write a query to incrementally populate the hosts_cumulated table from the web_events table.
*/

-- Insert new data into the 'hosts_cumulated' table
INSERT INTO hosts_cumulated
-- Define a CTE (Common Table Expression) named 'yesterday' to select data from the previous day
WITH yesterday AS 
(
    SELECT *
    FROM hosts_cumulated
    WHERE date = DATE('2022-12-31')  -- Select records where the date is December 31, 2022
),

-- Define another CTE named 'today' to select data from the current day

today AS 
(
    SELECT *
    FROM bootcamp.web_events
    WHERE DATE(event_time) = DATE('2023-01-01')  -- Select records where the event_time is January 1, 2023
)
SELECT DISTINCT 
    COALESCE(y.host, t.host) AS host,  -- Use the host from 'yesterday' or 'today', whichever is not NULL
    CASE 
        WHEN y.host_activity_datelist IS NOT NULL THEN
            ARRAY[DATE(t.event_time)] || y.host_activity_datelist  -- Append today's date to the existing date list
        ELSE 
            ARRAY[DATE(t.event_time)]  -- Initialize the date list with today's date if it doesn't exist
    END AS host_activity_datelist,
    DATE('2023-01-01') AS date  -- Set the date to January 1, 2023
FROM 
    yesterday y
FULL OUTER JOIN 
    today t 
ON 
    y.host = t.host -- Join on the host column
