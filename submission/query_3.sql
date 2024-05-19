INSERT INTO alissabdeltoro.user_devices_cumulated
-- Step 1: Define the yesterday CTE to capture the state of user_devices_cumulated table for the previous day.
WITH yesterday AS (
    SELECT * 
    FROM alissabdeltoro.user_devices_cumulated
    WHERE date = DATE '2022-12-31'
),

-- Step 2: Define the today CTE to capture events from the web_events table for the current day.
today AS (
    SELECT 
        we.user_id,
        d.browser_type,
        CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
        COUNT(1) AS event_count
    FROM academy.bootcamp.web_events we
    JOIN academy.bootcamp.devices d
        ON we.device_id = d.device_id
    WHERE date_trunc('day', we.event_time) = DATE '2023-01-01'
    GROUP BY we.user_id, d.browser_type, CAST(date_trunc('day', we.event_time) AS DATE)
),

-- Step 3: Insert into the user_devices_cumulated table by merging yesterday's data with today's data.
merged_data AS (
    SELECT 
        COALESCE(y.user_id, t.user_id) AS user_id,
        COALESCE(y.browser_type, t.browser_type) AS browser_type,
        CASE 
            WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
            ELSE ARRAY[t.event_date]
        END AS dates_active,
        DATE '2023-01-01' AS date
    FROM yesterday y
    FULL OUTER JOIN today t 
    ON y.user_id = t.user_id AND y.browser_type = t.browser_type
)

-- Step 4: Insert the merged data into the user_devices_cumulated table
SELECT * FROM merged_data
