-- user_devices_cumulated and web_events
yesterday AS (
    SELECT
        *
    FROM carloslaguna21592.user_devices_cumulated
    WHERE date = DATE('2023-01-01')

),
today AS (
    SELECT
        web.user_id AS user_id, 
        dev.browser_type AS browser_type,
        ARRAY_AGG(
            DISTINCT CAST(DATE_TRUNC('day', web.event_time) AS DATE)
        ) AS dates_active,
        DATE('2023-01-02') AS date
    FROM bootcamp.devices dev
    LEFT JOIN bootcamp.web_events web
    ON dev.device_id = web.device_id
    WHERE 
        DATE_TRUNC('day', web.event_time) = DATE('2023-01-02')
    GROUP BY user_id, browser_type
)

SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE 
        WHEN y.dates_active IS NULL THEN t.dates_active
        ELSE t.dates_active || y.dates_active -- order is important, today comes first
    END AS dates_active,
    t.date AS date
FROM yesterday y 
FULL OUTER JOIN today t
ON y.user_id = t.user_id