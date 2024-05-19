INSERT INTO meetapandit89096646.user_devices_cumulated
-- incremental load of web_events and devices cumulated table
WITH devices_events AS (
-- Merge web_evnets and devices tables to join users with their browser types
    -- user_id from web events table
SELECT we.user_id
    -- browser type from devices table
     , d.browser_type
     -- cast event time as date
     , CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date
     -- count users with same browser type
     , COUNT(*) AS cnt
FROM bootcamp.web_events we
LEFT JOIN bootcamp.devices d ON we.device_id = d.device_id
-- group by user,browser type and event day
GROUP BY we.user_id
     , d.browser_type
     , CAST(DATE_TRUNC('day', we.event_time) AS DATE)
)
-- select a date to begin incremental load
, yesterday AS (
SELECT *
FROM meetapandit89096646.user_devices_cumulated
WHERE date = DATE('2021-01-06')
)
-- today will have current date's data which will be appended to yesterday
, today AS (
  SELECT user_id
       , browser_type
       , event_date
  FROM devices_events
  WHERE event_date = DATE('2021-01-07') 
)

SELECT COALESCE(y.user_id, t.user_id) AS user_id
     , COALESCE(y.browser_type, t.browser_type) AS browser_type
     -- if yesterday and today's snapshot both have data then append both dates to array
     , CASE WHEN y.dates_active IS NOT NULL 
            THEN ARRAY[t.event_date] || y.dates_active
        -- if yesterday's date is null then create new array with today's data
       ELSE ARRAY[t.event_date]
       END AS dates_active
       -- current snapshot date
     , DATE('2021-01-07') AS date
FROM yesterday y
-- full ouetr join on user and browser type
FULL OUTER JOIN today t ON y.user_id = t.user_id
                       AND y.browser_type = t.browser_type
