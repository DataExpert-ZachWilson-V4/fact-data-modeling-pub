-- CUMULATED TABLE JOB will get loaded one day at a time
-- USING FULL OUTER JOIN to get data from both yesterday and today
-- LOAD dates_active (ARRAY) from date for user_id and browser_type

INSERT INTO tharwaninitin.user_devices_cumulated
WITH yesterday AS (
  SELECT *
  FROM tharwaninitin.user_devices_cumulated
  WHERE date = DATE('2022-12-31')
),
today AS (
  SELECT we.user_id, d.browser_type, CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date
  FROM bootcamp.web_events we
  JOIN bootcamp.devices d ON we.device_id = d.device_id
  WHERE CAST(DATE_TRUNC('day', we.event_time) AS DATE) = DATE('2023-01-01')
  GROUP BY we.user_id, d.browser_type, CAST(DATE_TRUNC('day', we.event_time) AS DATE)
)
SELECT COALESCE(y.user_id,t.user_id) as user_id,
  COALESCE(y.browser_type,t.browser_type) as browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS date
FROM yesterday y
FULL OUTER JOIN today t on y.user_id = t.user_id AND y.browser_type = t.browser_type