-- Insert data into the user_devices_cumulated table
INSERT INTO nonasj.user_devices_cumulated
WITH
  -- CTE to get the data from the previous day (yesterday)
  yesterday AS (
    SELECT
      user_id,
      browser_type,
      dates_active,
      date
    FROM
      nonasj.user_devices_cumulated
    WHERE
      date = DATE('2022-12-31') --example
  ),
  -- CTE to get the data for the current day (today)
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
      COUNT(1) AS event_count
    FROM
      bootcamp.web_events we
    LEFT JOIN
      bootcamp.devices d ON d.device_id = we.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-01')
    GROUP BY 1,2,3
  )
-- Select the final data to insert into the user_devices_cumulated table
SELECT
  -- If user_id from yesterday is null, use user_id from today and vice versa
  COALESCE(y.user_id, t.user_id) AS user_id,
  -- If browser_type from yesterday is null, use browser_type from today and vice versa
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  -- If dates_active from yesterday is not null, concatenate today's event_date with it, otherwise create a new array with today's event_date
    CASE
    WHEN y.dates_active IS NOT NULL and t.event_date is NOT NULL
    THEN ARRAY[t.event_date] || y.dates_active
    WHEN y.dates_active IS NOT NULL and t.event_date is NULL 
    THEN y.dates_active
    WHEN y.dates_active IS NULL THEN ARRAY[t.event_date]
  END AS dates_active,
  -- Set the date for the record to today's date
  DATE('2023-01-01') AS date
FROM
  -- Perform a full outer join between yesterday's and today's data on user_id and browser_type
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
