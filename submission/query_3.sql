INSERT INTO
    user_devices_cumulated WITH yesterday as (
        SELECT
            *
        FROM
            user_devices_cumulated
        WHERE
            date = DATE('2023-01-06') -- Selects data from the table for the date '2023-01-06' and stores it in a CTE named yesterday.
    ),
    today as (
        SELECT
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) as DATE) as event_date,
            COUNT(1)
        FROM
            bootcamp.web_events we
            JOIN bootcamp.devices d ON d.device_id = we.device_id
        WHERE
            date_trunc('day', we.event_time) = DATE('2023-01-07') -- Selects data from the web_events table for the date '2023-01-07' and stores it in a CTE named today.
        GROUP BY
            we.user_id,
            d.browser_type,
            CAST(date_trunc('day', we.event_time) as DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY [t.event_date] || y.dates_active -- If yesterday's dates_active array is not NULL, it concatenates today's event_date with yesterday's dates_active array.
        ELSE ARRAY [t.event_date] -- If yesterday's dates_active array is NULL, it initializes the dates_active array with today's event_date.
    END as dates_active,
    DATE('2023-01-07') as date -- Sets the date to '2023-01-07' for all inserted records.
FROM
    yesterday y FULL
    OUTER JOIN today t ON y.user_id = t.user_id -- Performs a full outer join between yesterday and today based on the user_id.