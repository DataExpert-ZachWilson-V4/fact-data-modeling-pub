INSERT INTO
    user_devices_cumulated WITH yesterday as (
        select
            *
        from
            user_devices_cumulated
        where
            date = DATE('2023-01-06')
    ),
    today as (
        select
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) as DATE) as event_date,
            COUNT(1)
        from
            bootcamp.web_events we
            join bootcamp.devices d on d.device_id = we.device_id
        where
            date_trunc('day', we.event_time) = DATE('2023-01-07')
        group by
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) as DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY [t.event_date] || y.dates_active
        ELSE ARRAY [t.event_date]
    END as dates_active,
    DATE('2023-01-07') as date
FROM
    yesterday y FULL
    OUTER JOIN today t on y.user_id = t.user_id