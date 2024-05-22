--User Devices Activity Datelist Implementation (query_3.sql)
--Write the incremental query to populate the table you wrote the DDL for in the above question from the web_events and
--devices tables. This should look like the query to generate the cumulation table from the fact modeling day 2 lab.

INSERT INTO saidaggupati.user_devices_cumulated
-- create CTE to hold yesterday's data
WITH
  old_data AS (
  SELECT * FROM saidaggupati.user_devices_cumulated
  WHERE DATE = DATE('2022-10-26')
  ),

-- CTE to hold current day's load

  current_day AS (
    SELECT web.user_id as user_id,device.browser_type as browser_type,
   CAST(date_trunc('day', web.event_time) AS DATE) AS event_date
    FROM bootcamp.web_events web LEFT JOIN bootcamp.devices device ON web.device_id = device.device_id
    WHERE date_trunc('day', web.event_time) = DATE('2022-10-27') -- 2022-10-27 as current day
    GROUP BY user_id,browser_type,CAST(date_trunc('day', event_time) AS DATE)
   )
   
--Main Query
SELECT
  COALESCE(od.user_id, cd.user_id) AS user_id,
  COALESCE(od.browser_type, cd.browser_type) AS browser_type,
--if user is active yesterday, concat the dates_Active to current date array.
  CASE WHEN od.dates_active IS NOT NULL THEN ARRAY[cd.event_date] || od.dates_active ELSE ARRAY[cd.event_date]
  END AS dates_active,
--setting current day parameter as DATE Column 
  DATE('2022-10-27') AS DATE
FROM old_data od FULL OUTER JOIN current_day cd 
  ON od.user_id = cd.user_id 