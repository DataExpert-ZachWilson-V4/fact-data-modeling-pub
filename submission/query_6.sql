-- This query incrementally populates the hosts_cumulated table by merging new web event data with the existing cumulative data.

-- Step 1: Define a CTE (Common Table Expression) for yesterday's data.
-- The yesterday CTE retrieves the records from hosts_cumulated for the previous day.
-- Step 2: Define a CTE for today's data.
-- The today CTE extracts the relevant data from the web_events table for today's date.
-- Step 3: Insert the merged data into hosts_cumulated.

INSERT INTO hosts_cumulated
WITH 
  -- Retrieve records from hosts_cumulated for the previous day
  yesterday AS (
    SELECT *
    FROM hosts_cumulated
    WHERE date = DATE('2022-12-01')  -- Assuming '2022-12-01' is the previous day
  ),

  -- Extract relevant data from web_events for today's date
  today AS (
    SELECT 
      host,
      DATE(date_trunc('day', event_time)) AS event_date  -- Extract the date from event_time
    FROM bootcamp.web_events
    WHERE DATE(date_trunc('day', event_time)) = DATE('2022-12-21')  -- Assuming '2022-12-21' is today's date
    GROUP BY host, DATE(date_trunc('day', event_time))  -- Group by host and event_date
  )

-- Merge yesterday's data with today's data and insert into hosts_cumulated
SELECT 
  COALESCE(t.host, y.host) AS host,  -- Take the non-null host value from either yesterday or today
  CASE
    WHEN y.host_activity_datelist IS NULL THEN ARRAY[t.event_date]  -- If no previous data, create a new array with today's date
    WHEN t.event_date IS NULL THEN y.host_activity_datelist  -- If no new data, keep the previous array
    ELSE ARRAY[t.event_date] || y.host_activity_datelist  -- Append today's date to the previous array
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date  -- Set the date for the new record
FROM 
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host  -- Join yesterday's and today's data based on the host
