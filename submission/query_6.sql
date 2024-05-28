-- Query to incrementally populate the hosts_cumulated table from the 
-- web_events table. (This is similar to query 3 but with host instead of user_id)

INSERT INTO positivelyamber.hosts_cumulated
WITH 
    yesterday AS (
        SELECT *
        FROM positivelyamber.hosts_cumulated
        WHERE date = DATE('2022-12-31')
    ),
    today AS (
        SELECT 
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            COUNT(1)
        FROM bootcamp.web_events
        -- LEFT JOIN bootcamp.devices d ON d.device_id = we.device_id
        WHERE date_trunc('day', event_time) = DATE('2023-01-01')
        GROUP BY 
            host,  
            CAST(date_trunc('day', event_time) AS DATE)
    )

SELECT
    COALESCE(y.host, t.host) as host,
    CASE 
        -- See if there are dates active before concat today's array to yesterday's       
        WHEN y.dates_active IS NOT NULL THEN Array[t.event_date] || y.dates_active
        -- If yesterday's dates_active are null start new array with today's
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-01') AS date

FROM yesterday y 
FULL OUTER JOIN today t 
ON y.host = t.host