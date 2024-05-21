-- commulative table to insert one day at the time

INSERT INTO nancycast01.user_devices_comulated

WITH yesterday AS (

  SELECT
  *
  FROM nancycast01.user_devices_comulated 
  WHERE date = DATE('2022-12-31')
),

today AS (

  SELECT 
    we.user_id,
    d.browser_type,
    CAST(date_trunc('day', we.event_time) AS DATE) AS event_date, --transforming ts
    COUNT(1)

  FROM bootcamp.web_events we
  LEFT JOIN bootcamp.devices d
    ON we.device_id = d.device_id
  
  WHERE date_trunc('day', we.event_time) = DATE('2023-01-01') -- first day of data
  GROUP BY 
  user_id,
  browser_type,
  CAST(date_trunc('day', event_time) AS DATE)
  
)

SELECT 
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS device_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-01') AS date 


FROM yesterday y
    FULL OUTER JOIN today t -- to ensure new users make it to the table
    ON y.user_id = t.user_id