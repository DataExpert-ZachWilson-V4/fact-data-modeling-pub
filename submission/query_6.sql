INSERT INTO hosts_cumulated
-- CTE to select records from previously aggregated data for yesterday's data
WITH yesterday AS (
  SELECT *
  FROM hosts_cumulated
  WHERE date = DATE('2022-12-31')
),
-- CTE to select and aggregate from raw data for today's data
today AS (
  SELECT
    host,
    DATE(event_time) AS event_date,  -- Extract the event date
    COUNT(1) AS count  -- Count the number of events per host
  FROM bootcamp.web_events
  WHERE DATE(event_time) = DATE('2023-01-01')
  GROUP BY
    host,
    DATE(event_time)
)
-- Select and combine data from both CTEs
SELECT
  COALESCE(y.host, t.host) AS host,  -- Use host from yesterday or today
  -- Combine the dates_active array from yesterday with today's event_date
  CASE
  -- Append today's event date to the existing array
    WHEN y.host_activity_datelist IS NOT NULL THEN 
      ARRAY[t.event_date] || y.host_activity_datelist
    -- If no dates_active from yesterday, start a new array with today's event date
    ELSE 
      ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS date  -- Set the date for the inserted records
FROM yesterday y
FULL OUTER JOIN today t ON y.host = t.host

-- Test the output table
-- SELECT *
-- FROM ibrahimsherif.hosts_cumulated
-- WHERE host = 'www.eczachly.com'
