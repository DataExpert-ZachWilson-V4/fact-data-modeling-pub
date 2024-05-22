INSERT INTO user_devices_cumulated 
-- CTE to select records from previously aggregated data for yesterday's data
WITH yesterday AS (
  SELECT *
  FROM user_devices_cumulated
  WHERE date = DATE('2022-12-31')
),
-- CTE to select and aggregate from raw data for today's data
today AS (
  SELECT
    w.user_id,
    d.browser_type,
    DATE(w.event_time) AS event_date,  -- Extract the event date
    COUNT(1) AS count  -- Count the number of events for each user and browser type
  FROM bootcamp.web_events w
  LEFT JOIN bootcamp.devices d ON w.device_id = d.device_id
  WHERE DATE(w.event_time) = DATE('2023-01-01')
  GROUP BY
    w.user_id,
    d.browser_type,
    DATE(w.event_time)
)
-- Select and combine data from both CTEs
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,  -- Use the user_id from yesterday or today
  COALESCE(y.browser_type, t.browser_type) AS browser_type,  -- Use the browser_type from yesterday or today
  -- Combine dates_active from yesterday with today's event date
  CASE
	  -- If yesterday's dates_active array is not empty
	  -- and today's active is not empty then concat today's date
    WHEN y.dates_active IS NOT NULL AND t.event_date IS NOT NULL
      THEN ARRAY[t.event_date] || y.dates_active
    -- If yesterday's dates_active array is not empty
	  -- and today's active is empty then return yesterday's date
    WHEN y.dates_active IS NOT NULL AND t.event_date IS NULL
      THEN y.dates_active
    -- If no dates_active from yesterday, start a new array with today's event date
    ELSE
      ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS date  -- Set the date for the inserted records
FROM yesterday y
FULL OUTER JOIN today t ON y.user_id = t.user_id

-- Test the output table
-- SELECT *
-- FROM user_devices_cumulated
-- WHERE
--   user_id IN (-1997364366, -1936905104, -1809293094, 889259381, -27044480)
-- ORDER BY user_id, date
