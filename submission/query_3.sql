-- This query populates one day of data incrementally into daily fact cumulated table `user_devices_cumulated`
INSERT INTO shashankkongara.user_devices_cumulated
WITH 
-- extract data of most recent date
yest AS (
    SELECT  
        *
    FROM 
        shashankkongara.user_devices_cumulated
    WHERE 
        DATE = DATE('2022-12-31')
),

-- We join `web_events` with `devices`, because we need to track daily user activity by browser type, we need both user_id and browser_type in the same table
joined AS (
    SELECT 
        a.*,
        b.browser_type,
        b.os_type,
        b.device_type
    FROM 
        bootcamp.web_events a
    INNER JOIN 
        bootcamp.devices b 
    ON 
        a.device_id = b.device_id
    WHERE 
        date_trunc('day', event_time) = DATE('2023-01-01') -- Adjust the date to process the next day's events
),

-- aggregates event data by user and browser type for today
today AS (
    SELECT 
        user_id,
        browser_type,
        CAST(date_trunc('day', event_time) AS DATE) AS event_date,
        COUNT(1) AS count_events -- Count of events per user per browser type per day
    FROM
        joined 
    GROUP BY
        user_id,
        browser_type,
        CAST(date_trunc('day', event_time) AS DATE)
)
-- Append new events to old if there are any, else we create an array of today's events
SELECT 
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-01') AS DATE
FROM 
    yest y 
FULL OUTER JOIN  -- FULL OUTER JOIN ensures we get data from both yesterday and today (old and new activity)
    today t 
ON 
    y.user_id = t.user_id AND y.browser_type = t.browser_type
