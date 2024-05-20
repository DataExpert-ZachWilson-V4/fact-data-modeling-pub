-- INSERT INTO user_devices_cumulated
WITH old_events AS (
    SELECT
        *
    FROM
        amaliah21315.user_devices_cumulated
    WHERE
        DATE = DATE('2021-01-18')
),
new_events AS (
    SELECT
        e.user_id,
        d.browser_type,
        CAST(date_trunc('day', e.event_time) AS DATE) AS event_date
    FROM
        bootcamp.web_events e
        LEFT JOIN bootcamp.devices d ON e.device_id = d.device_id
    WHERE
        date_trunc('day', e.event_time) = DATE('2021-01-19')
    GROUP BY
        e.user_id, d.device_id,
        CAST(date_trunc('day', e.event_time) AS DATE)
)
SELECT
    COALESCE(oe.user_id, ne.user_id) AS user_id,
    COALESCE(oe.browser_type, ne.browser_type) AS browser_type,
    CASE
        WHEN oe.dates_active IS NOT NULL THEN ARRAY [ne.event_date] || oe.dates_active
        ELSE ARRAY [ne.date]
    END AS dates_active,
    DATE('2021-01-19') AS DATE
FROM
    old_events oe FULL
    OUTER JOIN new_events ne ON oe.user_id = ne.user_id