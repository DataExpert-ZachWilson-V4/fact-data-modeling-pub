-- Define a CTE named 'agged'
WITH agged AS (
  -- Select user_id, browser_type, and event_time truncated to day from 'web_events' and 'devices' tables
  SELECT 
    w.user_id AS user_id,
    d.browser_type AS browser_type,
    CAST(date_trunc('day', w.event_time) AS DATE) AS event_time
  FROM 
    bootcamp.web_events w
    JOIN bootcamp.devices d ON w.device_id = d.device_id
),

-- Define a CTE named 'yesterday'
yesterday AS (
  -- Select all records from 'user_devices_cumulated' table for the date '2023-01-03'
  SELECT * 
  FROM ningde95.user_devices_cumulated
  WHERE date = DATE('2023-01-03')
),

-- Define a CTE named 'today'
today AS (
  -- Select user_id, browser_type, and event_time from 'agged' for the date '2023-01-04'
  -- Group by user_id, browser_type, and event_time
  SELECT 
    user_id,
    browser_type,
    event_time
  FROM agged
  WHERE date_trunc('day', event_time) = DATE('2023-01-04')
  GROUP BY user_id, browser_type, event_time
)

-- Final SELECT statement to combine 'yesterday' and 'today' data
SELECT 
  COALESCE(y.user_id, t.user_id) AS user_id,  -- Combine user_id from 'yesterday' and 'today'
  COALESCE(y.browser_type, t.browser_type) AS browser_type,  -- Combine browser_type from 'yesterday' and 'today'
  ARRAY[t.event_time] || COALESCE(y.dates_active, ARRAY[]) AS dates_active,  -- Combine dates_active from 'today' and 'yesterday'
  DATE('2023-01-04') AS date  -- Set the date for the combined data
FROM 
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
