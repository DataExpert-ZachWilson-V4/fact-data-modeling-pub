-- Insert the results of the query into the user_devices_cumulated table
INSERT INTO
  RaviT.user_devices_cumulated
-- Common Table Expression (CTE) to get data from the previous day
WITH
  yesterday AS (
    SELECT
      * -- Select all columns from the user_devices_cumulated table
    FROM
      RaviT.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31') -- Filter for the specific date
  ),
  -- CTE to get today's event data
  today AS (
    SELECT
      user_id,
      browser_type,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date, -- Truncate event_time to the day and cast it as a date
      count(1) -- Count the number of events for each user and browser_type
    FROM
      bootcamp.devices d
      JOIN bootcamp.web_events we ON d.device_id = we.device_id -- Join devices and web_events on device_id
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01')
    GROUP BY
      user_id,
      browser_type,
      CAST(date_trunc('day', event_time) AS DATE) -- Group by the truncated date
  )
-- Select the combined results from the CTEs
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id, -- Use the user_id from 'yesterday' if it exists, otherwise use the user_id from 'today'
  COALESCE(y.browser_type, t.browser_type) AS browser_type, -- Use the browser_type from 'yesterday' if it exists, otherwise use the browser_type from 'today'
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active -- If dates_active is not null, prepend today's event date
    ELSE ARRAY[t.event_date] -- If dates_active is null, create a new array with today's event date
  END AS dates_active,
  DATE('2023-01-01') AS DATE 
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id -- Full outer join on user_id to combine data from both days
