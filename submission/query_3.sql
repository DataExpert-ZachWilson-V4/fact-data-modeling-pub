INSERT INTO
    user_devices_cumulated
with
    yesterday as (
        select
            *
        from
            user_devices_cumulated
        where
            date = DATE('2023-01-04')
    ),
    today as (
        SELECT
            user_id,
            browser_type,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            event_time AS date
        FROM
            bootcamp.web_events we
            inner join bootcamp.devices de on we.device_id = de.device_id
        WHERE
            date_trunc('day', event_time) = DATE('2023-01-05')
        GROUP BY
            user_id,
            browser_type,
            event_time,
            CAST(date_trunc('day', event_time) AS DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-05') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.user_id = t.user_id