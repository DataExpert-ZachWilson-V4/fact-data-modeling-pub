INSERT INTO
  pratzo.user_devices_cumulated 
WITH
  yesterday AS (
    SELECT
      *
    FROM
      pratzo.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31')  -- previous day
  ),
  today AS (
    SELECT
      w.user_id as user_id,
      d.browser_type as browser_type,
      CAST(date_trunc('day', w.event_time) AS DATE) AS event_date,
      COUNT(1) -- Adding count for creating the datelist 
    FROM
      bootcamp.web_events w JOIN bootcamp.devices d ON w.device_id = d.device_id
    WHERE
      date_trunc('day', w.event_time) = DATE('2023-01-01')  -- current day
    GROUP BY
      w.user_id,
      d.browser_type,
      CAST(date_trunc('day', w.event_time) AS DATE)
   )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,  -- Handling NULLs
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  -- Populating the datelist array
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active -- If user was active yesterday, extend the array
    ELSE ARRAY[t.event_date]  
  END AS dates_active,
  DATE('2023-01-01') AS DATE  -- Setting date to the get 'current day' across all records to simplify viewing
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type