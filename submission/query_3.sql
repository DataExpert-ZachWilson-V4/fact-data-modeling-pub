INSERT INTO crouton.user_devices_cumulated
WITH old_data AS (
    SELECT *
    FROM crouton.user_devices_cumulated
    WHERE date = DATE('2022-09-29')
),

new_data AS (
    SELECT 
        web.user_id AS user_id,
        dev.browser_type AS browser_type,
        DATE(web.event_time) AS dates_active
    FROM bootcamp.devices dev
    JOIN bootcamp.web_events web ON dev.device_id = web.device_id
    WHERE DATE(web.event_time) = DATE('2022-09-30')
    GROUP BY web.user_id, dev.browser_type, DATE(web.event_time)
)

SELECT 
    COALESCE(od.user_id, nd.user_id) AS user_id,
    COALESCE(od.browser_type, nd.browser_type) AS browser_type,
    CASE 
        WHEN od.dates_active IS NOT NULL THEN ARRAY[nd.dates_active] || od.dates_active 
        ELSE ARRAY[nd.dates_active]
    END AS dates_active,
    DATE('2022-09-30') AS date
FROM old_data od
FULL OUTER JOIN new_data nd 
ON od.user_id = nd.user_id
AND nd.browser_type = od.browser_type