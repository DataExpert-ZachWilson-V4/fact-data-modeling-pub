-- Host Activity Datelist Implementation (query_6.sql)
-- This query incrementally populates the hosts_cumulated table from the web_events table.

INSERT INTO hosts_cumulated (host, host_activity_datelist, date)
-- Step 1: Define the yesterday CTE to capture the state of hosts_cumulated table for the previous day.
WITH
  yesterday AS (
    SELECT
      host,
      host_activity_datelist
    FROM
      hosts_cumulated
    WHERE
      DATE = DATE '2023-04-08'
  ),
  -- Step 2: Define the today CTE to capture events from the web_events table for the current day.
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE '2023-04-09'
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  ),
  -- Step 3: Merge yesterday's data with today's data.
  merged_data AS (
    SELECT
      COALESCE(y.host, t.host) AS host,
      CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
      END AS host_activity_datelist,
      DATE '2023-04-09' AS date
    FROM
      yesterday y
      FULL OUTER JOIN today t ON y.host = t.host
  )

-- Insert the merged data for the current day
SELECT
  host,
  host_activity_datelist,
  date
FROM
  merged_data
