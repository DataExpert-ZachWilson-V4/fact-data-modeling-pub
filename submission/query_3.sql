    -- Subqueries:
    --     yesterday: Selects all records from alia.user_devices_cumulated where the date is January 8, 2023.
    --     today: Aggregates web event data from bootcamp.web_events for January 9, 2023, joined with bootcamp.devices to get browser type, grouped by user ID and browser type.

    -- Insert Operation:
    --     Merges data from yesterday (y) and today (t) using a full outer join on user_id and browser_type.
    --     Combines the event dates from today with the existing dates_active from yesterday. If there are no existing dates, it initializes with the event date from today.
    --     Inserts the results with the date set to January 9, 2023.

INSERT INTO
    alia.user_devices_cumulated
WITH
    yesterday AS (
        SELECT
            *
        FROM
            alia.user_devices_cumulated
        WHERE
            DATE = DATE('2023-01-08')
    ),
    today AS (
        SELECT
            web.user_id,
            devices.browser_type,
            CAST(date_trunc('day', web.event_time) AS DATE) AS event_date,
            COUNT(1)
        FROM
            bootcamp.web_events web
            inner join bootcamp.devices devices on web.device_id = devices.device_id
        WHERE
            date_trunc('day', event_time) = DATE('2023-01-09')
        GROUP BY
            web.user_id,
            devices.browser_type,
            CAST(date_trunc('day', web.event_time) AS DATE)
    )
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-09') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.user_id = t.user_id
    and y.browser_type = t.browser_type