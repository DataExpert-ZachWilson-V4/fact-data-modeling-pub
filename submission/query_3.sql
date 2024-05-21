INSERT INTO
    barrocaeric.user_devices_cumulated
WITH
    yesterday AS (
        SELECT
            *
        FROM
            barrocaeric.user_devices_cumulated
        WHERE
            date = DATE('2022-12-31')
    ),
    today AS (
        SELECT
            w.user_id,
            -- adding browser type
            d.browser_type,
            CAST(date_trunc('day', w.event_time) as DATE) as event_date,
            COUNT(1)
        FROM
            bootcamp.web_events w
            -- joinning with devices
            JOIN bootcamp.devices d ON w.device_id = d.device_id
        WHERE
            date_trunc('day', w.event_time) = DATE('2023-01-01')
        GROUP BY
            w.user_id,
            -- adding devices to group by to get the event date based on user_id and browser_type
            d.device_id,
            d.browser_type,
            CAST(date_trunc('day', w.event_time) as DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END as dates_active,
    DATE('2023-01-01') as date
FROM
    yesterday y
    -- adding browser_type to the join to guarantee actives date by user_id and browser_type
    FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type