-- The purpose of this query is to populate the user_devices_cumulated table incrementally.
-- This query inserts data by combining the previous day's data with today's new events.
-- It ensures that the dates_active array is updated with the most recent date of activity for each user and browser_type combination.


INSERT INTO
  vpsjul8468082.user_devices_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      vpsjul8468082.user_devices_cumulated
    WHERE
      date =  DATE('2022-12-31')
  ),
  today AS (
    SELECT
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      academy.bootcamp.web_events we
    JOIN
      academy.bootcamp.devices d ON we.device_id = d.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-01')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
