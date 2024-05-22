INSERT INTO user_devices_cumulative
WITH yesterday AS (
        SELECT
            *
        FROM
            user_devices_cumulative
        WHERE
            DATE = DATE('2022-12-31')
    ),
    today AS (
        SELECT
            user_id,
            browser_type,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date
        FROM
            bootcamp.web_events w
            left join bootcamp.devices d on d.device_id = w.device_id
        WHERE
            date_trunc('day', event_time) = DATE('2023-01-01') --and user_id= 1320602989
        GROUP BY
            user_id,
            browser_type,
            CAST(date_trunc('day', event_time) AS DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL and t.event_date is NOT NULL
             THEN ARRAY [t.event_date] || y.dates_active
        WHEN y.dates_active IS NOT NULL and t.event_date is NULL THEN y.dates_active
        WHEN y.dates_active IS NULL THEN ARRAY[t.event_date] 
    END AS dates_active,
    DATE('2023-01-01') AS DATE
FROM
    yesterday y FULL
    OUTER JOIN today t ON y.user_id = t.user_id
    AND y.browser_type = t.browser_type