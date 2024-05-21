INSERT INTO user_devices_cumulated
WITH
yesterday AS (
    SELECT *
    FROM
        user_devices_cumulated
    WHERE
        date = DATE('2022-12-31')
),

today_w_browser AS (
    SELECT
        w.user_id,
        d.browser_type,
        w.event_time
    FROM
        bootcamp.web_events AS w
    LEFT JOIN bootcamp.devices AS d ON w.device_id = d.device_id
    WHERE
        DATE_TRUNC('day', event_time) = DATE('2023-01-01')
),

today AS (
    SELECT
        user_id,
        browser_type,
        CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date,
        COUNT(*) AS count
    FROM
        today_w_browser
    GROUP BY
        user_id,
        browser_type,
        CAST(DATE_TRUNC('day', event_time) AS DATE)
)

SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN
            y.dates_active IS NOT NULL
            THEN array[t.event_date] || y.dates_active
        ELSE array[t.event_date]
    END AS dates_active,
    DATE('2023-01-01') AS date
FROM
    yesterday AS y
FULL OUTER JOIN today
    AS t ON y.user_id = t.user_id
AND y.browser_type = t.browser_type
