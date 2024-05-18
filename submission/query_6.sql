INSERT INTO videet.hosts_cumulated
-- Define two Common Table Expressions (CTEs) to process host activities from different days.
WITH 
yesterday AS ( 
  -- The 'yesterday' CTE retrieves data from 'hosts_cumulated' for a specific previous date.
  -- This data includes the host, their activity dates, and the last recorded date.
  SELECT 
    host,
    host_activity_datelist,
    date
  FROM 
    videet.hosts_cumulated
  WHERE 
    date = DATE('2023-01-01')  -- Targeting the data of January 1, 2023.
  -- Note: If it's the first day of data collection, this CTE will be empty.
),
today AS (
  -- The 'today' CTE aggregates new event data from the 'web_events' table for January 2, 2023.
  SELECT
    host,
    CAST(date_trunc('day', event_time) AS DATE) AS event_date,
    -- The event time is truncated to date to standardize and align with the datelist structure.
    COUNT(1) AS cnt -- Count of events is captured here for debugging and validation purposes.
  FROM 
    bootcamp.web_events
  WHERE 
    date_trunc('day', event_time) = DATE('2023-01-02')  -- Filtering events for January 2, 2023.
  GROUP BY 
    host,
    CAST(date_trunc('day', event_time) AS DATE) -- Grouping by host and the truncated event date.
)

-- The final query merges the data from 'yesterday' and 'today' CTEs.
-- It uses a full outer join on the host key to ensure all data is captured.
SELECT 
  COALESCE(y.host, t.host) AS host, -- Coalesce ensures no null host values, taking values from either CTE.
  CASE 
    WHEN y.host_activity_datelist IS NOT NULL THEN
      ARRAY[t.event_date] || y.host_activity_datelist -- If yesterday's list exists, today's date is appended.
    ELSE
      ARRAY[t.event_date] -- If no prior list exists, start a new array with today's date.
  END AS host_activity_datelist,
  COALESCE(y.date + INTERVAL '1' DAY, t.event_date) AS date -- Adjust the date to show continuity.
FROM 
  yesterday y
FULL OUTER JOIN 
  today t 
ON 
  t.host = y.host  -- Joining on host to align the activities per host.