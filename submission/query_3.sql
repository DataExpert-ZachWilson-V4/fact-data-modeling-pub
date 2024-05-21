INSERT INTO martinaandrulli.user_devices_cumulated
--- CTE getting data from the previous day of the user_devices_cumulated table as past data where to join the new one
WITH yesterday_user_device_cumulated AS (
  SELECT *
  FROM martinaandrulli.user_devices_cumulated
  WHERE date = DATE('2021-03-24')
),
--- CTE getting 'new' data from the web_events table
today_events_cte AS (
  SELECT 
    user_id,
    device_id,
    CAST(date_trunc('day', event_time) AS DATE) AS event_date -- We need only the 'date' of the field, without the timestamp
  FROM bootcamp.web_events
  WHERE CAST(date_trunc('day', event_time) AS DATE) = DATE('2021-03-25')
 --- By grouping by user_id, device_id and event_date, we ensure that if a user_id has used two different device_id on the same day, this generates two separated entries.
  GROUP BY user_id, device_id, CAST(date_trunc('day', event_time) AS DATE)
),
--- CTE joining information from the web_events table with the devices table. In this way we know for each user_id, which was the browser_type he was using.
today_user_device_cumulated AS (
  SELECT
    ud.user_id AS user_id,
    dev.browser_type AS browser_type,
    ud.event_date AS event_date
  FROM today_events_cte AS ud
  -- A join with the devices table is required to get the broswer type of each device_id.
  -- Nevertheless, a LEFT outer join is used since we are only interesting in knowing the browser_type for those Device IDs used in the web_events table. Those device_id that are not present in the web_events table are useless.
  LEFT OUTER JOIN bootcamp.devices AS dev 
  ON ud.device_id = dev.device_id
  -- By grouping by user_id, browser_type and event_date, it is covered the case in which the same browser_type coming from different device_id is considered as a single entry.
  GROUP BY 1, 2, 3 
)
SELECT 
  -- If the user was already present in the past data, we use that ID. If it's a new user never seen before, we user the ID from the "new" data
  COALESCE(yud.user_id, tud.user_id) AS user_id,
  -- If the browser was already present in the past data, we use that value. If it's a new user never seen before, we user the browser from the "new" data
  COALESCE(yud.browser_type, tud.browser_type) AS browser_type,
  CASE
    -- If we have already an entry of date_active from the past that match userID/browser, we just update the list by adding the new data
    WHEN yud.dates_active IS NOT NULL THEN ARRAY[tud.event_date] || yud.dates_active
    -- If the user is new, we don't have any entry of date_active from the past that match userID/browser, we just use the new data value
    ELSE ARRAY[tud.event_date]
  END AS dates_active,
  -- If new data are found for that entry, the date is the one coming from the 'today' table. But, if no new entry is found for that userID/browser, we add one year to the previous year to get the current one.
  COALESCE(tud.event_date, date_add('day',1,yud.date)) AS DATE
FROM yesterday_user_device_cumulated AS yud 
FULL OUTER JOIN today_user_device_cumulated AS tud
ON yud.user_id = tud.user_id