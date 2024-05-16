INSERT INTO user_devices_cumulated
WITH
    yesterday AS (
        SELECT
            *
        FROM
            user_devices_cumulated
        WHERE
            date = DATE('2024-05-14')
    ),
    today AS (
        SELECT
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) AS DATE) as event_date,
            COUNT(1)
        FROM
            bootcamp.web_events AS we
        LEFT JOIN bootcamp.devices AS d ON d.device_id = we.device_id
        WHERE
            date_trunc('day', we.event_time) = DATE('2024-05-15')
        GROUP BY
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) AS DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN CONCAT(ARRAY[t.event_date], y.dates_active)
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2024-05-15') AS date
FROM yesterday AS y
FULL OUTER JOIN today AS t ON t.user_id = y.user_id AND t.browser_type = y.browser_type