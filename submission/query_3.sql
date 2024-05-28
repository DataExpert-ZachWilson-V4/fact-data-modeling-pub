-- Incremental query to populate the user_devices_cumulated table 
-- from the web_events and devices
INSERT INTO positivelyamber.user_devices_cumulated
WITH 
    yesterday AS (
        SELECT *
        FROM positivelyamber.user_devices_cumulated
        WHERE date = DATE('2022-12-31')
    ),
    today AS (
        SELECT 
            user_id,
            browser_type,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            COUNT(1)
        FROM bootcamp.web_events we
        LEFT JOIN bootcamp.devices d ON d.device_id = we.device_id
        WHERE date_trunc('day', event_time) = DATE('2023-01-01')
        GROUP BY 
            user_id, 
            browser_type, 
            CAST(date_trunc('day', event_time) AS DATE)
    )

SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE 
        -- See if there are dates active before concat today's array to yesterday's       
        WHEN y.dates_active IS NOT NULL THEN Array[t.event_date] || y.dates_active
        -- If yesterday's dates_active are null start new array with today's
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-01') AS date
FROM yesterday y 
FULL OUTER JOIN today t 
ON y.user_id = t.user_id AND y.browser_type = t.browser_type