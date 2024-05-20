-- ncrementally load ovoxo.user_devices_cummulated using bootcamp.web_events and bootcamp.devices

INSERT INTO ovoxo.user_devices_cummulated
WITH
  -- get exisiting previous day records from ovoxo.user_devices_cummulated
  previous_date_records AS (
    SELECT *
    FROM ovoxo.user_devices_cummulated
    WHERE date = DATE('2023-01-06')  
  ),
  
  -- get current day records from base tables. web_events and devices are joined to get browser_type from device_id
  current_date_records AS (
    SELECT e.user_id,
      d.browser_type,
      CAST(date_trunc('day', e.event_time) AS DATE) AS event_date
    FROM bootcamp.web_events e
    LEFT JOIN bootcamp.devices d ON d.device_id = e.device_id
    WHERE date_trunc('day', e.event_time) = DATE('2023-01-07')
    GROUP BY e.user_id, d.browser_type, CAST(date_trunc('day', e.event_time) AS DATE)
  )
  
SELECT 
  COALESCE(p.user_id, c.user_id) AS user_id,
  COALESCE(p.browser_type, c.browser_type) AS browser_type,
  CASE 
    WHEN p.dates_active IS NOT NULL THEN ARRAY[c.event_date] || p.dates_active -- if there is an existing array from previous day, concat with current day. Current day record is first record
    ELSE ARRAY[c.event_date] -- if no records from previous day, use current day to create array
  END AS dates_active,
  DATE('2023-01-07') AS date
FROM previous_date_records p
FULL OUTER JOIN current_date_records c ON c.user_id = p.user_id AND c.browser_type = p.browser_type
