 with yesterday as (
  SELECT 
    * 
  FROM 
    adbeyer.user_devices_cumulated 
  WHERE 
    date = DATE('2022-12-31')
), 
today as (
  SELECT 
    user_id, 
    browser_type, 
    COUNT(1) as cnt, 
    DATE(
      CAST(event_time as TIMESTAMP)
    ) as date_active 
  FROM 
    bootcamp.web_events we 
    JOIN bootcamp.devices d ON we.device_id = d.device_id 
  WHERE 
    DATE(
      CAST(event_time as TIMESTAMP)
    ) = DATE('2022-10-01') 
  GROUP BY 
    1, 
    2, 
    4
) 
SELECT 
  COALESCE(
    yesterday.user_id, today.user_id
  ) as user_id, 
  COALESCE(
    yesterday.browser_type, today.browser_type
  ) as browser_type, 
  CASE WHEN yesterday.dates_active is null THEN ARRAY[today.date_active] WHEN today.date_active is null THEN yesterday.dates_active ELSE ARRAY[today.date_active] || yesterday.dates_active END as dates_active, 
  COALESCE(
    today.date_active, 
    date_add('day', 1, yesterday.date)
  ) as date 
FROM 
  today FULL 
  OUTER JOIN yesterday ON today.user_id = yesterday.user_id 
  and today.browser_type = yesterday.browser_type
