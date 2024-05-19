INSERT INTO user_devices_cumulated WITH yesterday AS (
    --  Select the data from the previous day
    SELECT *
    FROM user_devices_cumulated
    WHERE DATE = DATE('2023-01-07') - INTERVAL '1' DAY
  ),
  today AS (
    -- Create a today data which gets a count of the user's activity
    -- Not that the count is used
    SELECT user_id,
    -- Cast timestamp to date
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      d.browser_type,
      -- Use count to aggregate the data
      COUNT(1)
    FROM bootcamp.web_events as w
    -- Join in the devices table to get both browser_type and user_id
      JOIN bootcamp.devices as d ON w.device_id = d.device_id
    WHERE date_trunc('day', event_time) = DATE('2023-01-07')
    GROUP BY user_id,
      CAST(date_trunc('day', event_time) AS DATE),
      d.browser_type
  )
-- Use a FULL OUTER JOIN to combine the data from yesterday and today
SELECT COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) as browser_type,
  -- If the user was active yesterday, add the date to the array
  CASE
  -- Old user case
    WHEN y.dates_active IS NOT NULL THEN ARRAY [t.event_date] || y.dates_active
  -- If the user was active today, add the date to the array
  -- Also covers the new user case for users who were active today but not yesterday
  -- and the null case for users who were active yesterday but not today
    ELSE ARRAY [t.event_date]
  END AS dates_active,
  DATE('2023-01-07') AS DATE
FROM yesterday y
  -- Ensure both tables are joined on the user_id and browser_type fields
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type