/*
This SQL query performs an insertion into the nikhilsahni.user_devices_cumulated table by aggregating
user-device data from web events and devices, handling duplicates, and combining historical data with 
new data 
*/
INSERT INTO
  nikhilsahni.user_devices_cumulated
/*
  This common table expression (CTE) named combined joins the bootcamp.web_events table with the bootcamp.devices 
  table on device_id, selecting the user_id, device_id, browser_type, and truncating event_time to the day level 
  to get event_date.
*/
WITH
  combined AS (
    SELECT
      we.user_id AS user_id,
      we.device_id AS device_id,
      d.browser_type AS browser_type,
      DATE(DATE_TRUNC('day', event_time)) AS event_date
    FROM
      bootcamp.web_events AS we
      LEFT JOIN bootcamp.devices AS d ON we.device_id = d.device_id
  ),
/*
  The dupes CTE groups the data from combined by user_id, browser_type, and event_date, counting the number 
  of occurrences for each group to identify potential duplicates.
*/
  dupes AS (
    SELECT
      user_id,
      browser_type,
      event_date,
      COUNT(*) AS cnt
    FROM
      combined
    GROUP BY
      user_id,
      browser_type,
      event_date
  ),
/*
  The deduped CTE selects the user_id, browser_type, and event_date from dupes, effectively removing 
  duplicate entries by keeping only the grouped columns.
*/
  deduped AS (
    SELECT
      user_id,
      browser_type,
      event_date
    FROM
      dupes
  ),
/*
  The yesterday CTE selects all records from the nikhilsahni.user_devices_cumulated table where the date is 
  December 31, 2022, representing historical data up to the day before the new data.
*/
  yesterday AS (
    SELECT
      user_id,
      browser_type,
      dates_active 
    FROM
      nikhilsahni.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31')
  ),
/*
  The today CTE selects all records from the deduped CTE where the event_date is January 1, 2023, 
  representing the new data for the current day.
*/
  today AS (
    SELECT
      user_id,
      browser_type,
      event_date
    FROM
      deduped
    WHERE
      event_date = DATE('2023-01-01')
  )
/*
  This part performs a full outer join between the yesterday and today CTEs on user_id and browser_type 
  to combine historical and current data. user_id and browser_type, using COALESCE to prefer today's values 
  if present. dates_active, which is an array, Initializes with today's date if user_id is new.
  Appends today's date to the existing array if user_id exists both in yesterday's and today's data.
  Keeps the existing array if user_id exists only in yesterday's data.
  A constant DATE value set to January 1, 2023.
*/
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.user_id IS NULL THEN ARRAY[t.event_date]
    WHEN y.user_id IS NOT NULL
    AND t.user_id IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    WHEN y.user_id IS NOT NULL
    AND t.user_id IS NULL THEN y.dates_active
  END AS dates_active,
  DATE('2023-01-01') AS DATE
FROM
  yesterday AS y
  FULL OUTER JOIN today AS t ON y.user_id = t.user_id
  AND y.browser_type = t.browser_type
