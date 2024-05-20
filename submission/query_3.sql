-- Insert new and updated user device data into the user_devices_cumulated table
INSERT INTO faraanakmirzaei15025.user_devices_cumulated
WITH old_data AS (
  -- Select existing data from user_devices_cumulated for the specific date
  SELECT
    *
  FROM
    faraanakmirzaei15025.user_devices_cumulated
  WHERE
    date = DATE('2021-06-07')
),
new_data AS (
  -- Select new data from web_events and devices for the specific date
  SELECT
    we.user_id,
    d.browser_type,
    DATE(we.event_time) AS event_date
  FROM
    bootcamp.web_events we
  LEFT JOIN
    bootcamp.devices d
  ON
    d.device_id = we.device_id
  WHERE
    DATE(event_time) = DATE('2021-06-08')
  GROUP BY
    we.user_id,
    d.browser_type,
    DATE(we.event_time)
)
-- Combine old and new data, giving preference to new data where it exists
SELECT
  COALESCE(nd.user_id, od.user_id) AS user_id,
  COALESCE(nd.browser_type, od.browser_type) AS browser_type,
  CASE
    WHEN od.dates_active IS NULL THEN ARRAY[nd.event_date]
    ELSE ARRAY[nd.event_date] || od.dates_active
  END AS dates_active,
  DATE('2021-06-08') AS date
FROM
  new_data nd
FULL OUTER JOIN
  old_data od
ON
  nd.user_id = od.user_id
  AND nd.browser_type = od.browser_type
