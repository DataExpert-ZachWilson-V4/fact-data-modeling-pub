INSERT INTO  malmarzooq80856.user_devices_cumulated 
WITH yesterday AS (
        SELECT *
        FROM malmarzooq80856.user_devices_cumulated
        WHERE date = DATE('2022-12-01')
),
today AS (
        SELECT 
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) AS DATE) AS date
        FROM bootcamp.web_events we
        JOIN bootcamp.devices d ON d.device_id = we.device_id
        WHERE date_trunc('day', event_time) = DATE('2022-12-02')
        GROUP BY 
            user_id, 
            browser_type, 
            CAST(date_trunc('day', we.event_time) AS DATE)
)
SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE 
        WHEN y.dates_active IS NOT NULL THEN Array[t.date] || y.dates_active
        ELSE ARRAY[t.date]
    END AS dates_active,
    t.date AS date
FROM yesterday y 
FULL OUTER JOIN today t 
ON y.user_id = t.user_id AND y.browser_type = t.browser_type