-- The purpose of this query is to populate the user_devices_cumulated table incrementally.
-- This query inserts data by combining the previous day's data with today's new events.
-- It ensures that the dates_active array is updated with the most recent date of activity for each user and browser_type combination.

INSERT INTO user_devices_cumulated (
    user_id,
    browser_type,
    dates_active,
    date
)
WITH
  -- Select all records from the user_devices_cumulated table for the previous day
  yesterday AS (
    SELECT
      user_id,
      browser_type,
      dates_active,
      date
    FROM
      user_devices_cumulated
    WHERE
      date = DATE('2022-12-01')
  ),
  -- Select all web events from today, joining with the devices table to get the browser type
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events we
    JOIN
      bootcamp.devices d ON we.device_id = d.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2022-12-02')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
SELECT
  -- Combine user_id and browser_type from yesterday and today
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  -- Update the dates_active array to include today's event date, maintaining previous dates
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  -- Set the date to the current date
  CURRENT_DATE AS date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
