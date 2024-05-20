INSERT INTO dennisgera.user_devices_cumulated 

WITH yesterday AS (
        SELECT
            *
        FROM
            dennisgera.user_devices_cumulated
        WHERE
            DATE = DATE('2022-12-31')
    ),
    today AS (
        SELECT
            we.user_id,
            d.browser_type,
            CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date,
            COUNT(
                *
            ) AS event_count
        FROM
            bootcamp.web_events AS we
            JOIN bootcamp.devices AS d
            ON we.device_id = d.device_id
        WHERE
            DATE(event_time) = DATE('2023-01-01')
        GROUP BY
            1,
            2,
            3
    )
SELECT
    COALESCE(
        y.user_id,
        t.user_id
    ) AS user_id,
    COALESCE(
        y.browser_type,
        t.browser_type
    ) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY [t.event_date] || y.dates_active
        ELSE ARRAY [t.event_date]
    END AS dates_active,
    COALESCE(t.event_date, date_add('day', 1, y.date)) AS date
FROM
    yesterday y full
    OUTER JOIN today t
    ON y.user_id = t.user_id
    AND y.browser_type = t.browser_type
