-- query_3 User Devices Activity Datelist Implementation
-- The incremental query to populate user_devices_cumulated table from the web_events and devices tables.

INSERT INTO
  aayushi.user_devices_cumulated 
WITH
  yesterday AS (
    SELECT
      *
    FROM
      aayushi.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31')  -- Selecting data for the previous day
  ),  -- CTE to fetch data for the previous day (2022-12-31)

  today AS (
    SELECT
        w.user_id as user_id
      , d.browser_type as browser_type
      , CAST(date_trunc('day', w.event_time) AS DATE) AS event_date
      , COUNT(1) -- Adding count for creating the datelist
    FROM
      bootcamp.web_events w 
    JOIN bootcamp.devices d 
        ON w.device_id = d.device_id
    WHERE
      date_trunc('day', w.event_time) = DATE('2023-01-01')  -- Selecting data for the current day
    GROUP BY
        w.user_id
      , d.browser_type
      , CAST(date_trunc('day', w.event_time) AS DATE)
   )  -- CTE to fetch data for the current day (2023-01-01)

-- Main query to insert aggregated data into user_devices_cumulated table
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id   -- Using COALESCE to handle NULL values
  , COALESCE(y.browser_type, t.browser_type) AS browser_type
  -- Populating date_list array, if user was active yesterday, append yesterday's dates to today's dates_active array
  , CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]  -- If user was not active yesterday, set today's date as the only active date
    END AS dates_active
  , DATE('2023-01-01') AS DATE  -- Setting the date as 2023-01-01 for all records for simplified view
FROM
    yesterday y
FULL OUTER JOIN today t 
    ON y.user_id = t.user_id AND y.browser_type = t.browser_type


-- did the incremental till '2023-01-07'