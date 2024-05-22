-- Incremental query to populate user_devices_cumulated from the web_events and devices tables

INSERT INTO shruthishridhar.user_devices_cumulated
WITH
    yesterday AS (
        SELECT * FROM shruthishridhar.user_devices_cumulated
        WHERE DATE = DATE('2021-01-02') -- earliest date in web_events table
    ),
    today AS (
        SELECT
            events.user_id AS user_id,
            devices.browser_type AS browser_type,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            COUNT(1) AS dates_active    -- get count of browsing events for current combination
        FROM bootcamp.web_events events
        LEFT JOIN bootcamp.devices devices  -- join devices and web events on devices
        ON events.device_id = devices.device_id
        WHERE date_trunc('day', event_time) = DATE('2021-01-03')    -- get date alone from event time
        GROUP BY 1, 2, 3    -- group by user_id, broweser_type and date
    )
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL AND t.event_date IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active -- if both are there, combine with today's first followed by yesterday's
        WHEN y.dates_active IS NOT NULL THEN y.dates_active -- if today's event is null, use yesterday's
        WHEN t.event_date IS NOT NULL THEN ARRAY[t.event_date]  -- if yesterday's event is null, use today's
    END AS dates_active,
    DATE('2021-01-03') AS DATE
FROM yesterday y
FULL OUTER JOIN today t
ON y.user_id = t.user_id AND y.browser_type = t.browser_type