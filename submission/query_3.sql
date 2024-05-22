-- query_3
INSERT INTO qhamzah.user_devices_cumulated
WITH
  -- previously backfilled data from the specified date
  yesterday AS (
    SELECT *
      FROM qhamzah.user_devices_cumulated
     WHERE date = DATE('2022-12-31')
  ),
  -- upcoming data to be loaded by user_id and browser_type for the specified date
  today AS (
    SELECT
      w.user_id,
      d.browser_type,
      CAST(date_trunc('day', w.event_time) AS date) AS event_date,
      -- Count the number of events for the combination of user_id and browser_type
      COUNT(1)
      FROM bootcamp.web_events w
      JOIN bootcamp.devices d ON w.device_id = d.device_id
     WHERE date_trunc('day', w.event_time) = DATE('2023-01-01')
     GROUP BY w.user_id, d.browser_type, date_trunc('day', event_time)
  )
  
--  Select and combine data from 'yesterday' and 'today'
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  -- Append event_date if dates_active exist, else create single-item array with event_date
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE'2023-01-01' AS date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
