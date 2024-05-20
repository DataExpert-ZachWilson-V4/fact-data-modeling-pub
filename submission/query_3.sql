-- Inserting data into the table "user_devices_cumulated"
INSERT INTO user_devices_cumulated
-- Using Common Table Expressions (CTEs) to organize the query
WITH
  -- CTE to fetch data from yesterday (2021-01-17)
  yesterday AS (
    SELECT
      *
    FROM
      user_devices_cumulated
    WHERE
      DATE = DATE('2021-01-17')
  ),
  -- CTE to fetch data from today (2021-01-18)
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) as event_date,
      COUNT(1)
    FROM
      bootcamp.web_events AS we
    LEFT JOIN bootcamp.devices AS d ON d.device_id = we.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2021-01-18')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
-- Selecting data from yesterday and today and combining them
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,                -- Choose user_id from yesterday if available, else from today
  COALESCE(y.browser_type, t.browser_type) AS browser_type, -- Choose browser_type from yesterday if available, else from today
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active  -- If there are active dates from yesterday, append today's date
    ELSE ARRAY[t.event_date]    -- If there are no active dates from yesterday, create a new array with today's date
  END AS dates_active,          -- Determine the dates_active array
  DATE('2021-01-18') AS date    -- Set the date as '2021-01-18' for the new row
FROM
  yesterday y                   -- Left table of the FULL OUTER JOIN
  FULL OUTER JOIN today t      -- Right table of the FULL OUTER JOIN
  ON y.user_id = t.user_id AND y.browser_type = t.browser_type  -- Joining conditions
