-- Inserts data into the "user_devices_cumulated" table combined from web events and devices
INSERT INTO
    amaliah21315.user_devices_cumulated WITH old_events AS ( 
        -- Subquery to select all records from "user_devices_cumulated" for a specific date
        SELECT
            *
        FROM
            amaliah21315.user_devices_cumulated 
        WHERE
            DATE = DATE('2022-03-10') -- Filter table for specific dates cumulation
    ),
    new_events AS (
         -- Subquery to select new event data from "web_events" and "devices" tables
        SELECT
            e.user_id, -- Users id from the web event
            d.browser_type,  -- Browser type from devices received through join
            CAST(date_trunc('day', e.event_time) AS DATE) AS event_date -- select the event date excluding the time
        FROM
            bootcamp.web_events e
            LEFT JOIN bootcamp.devices d ON e.device_id = d.device_id  -- Join with "devices" table to get browser type
        WHERE
            date_trunc('day', e.event_time) = DATE('2022-03-11') -- Filter events to only include those that occurred on '2022-03-11
        GROUP BY
            e.user_id, -- Gets web events grouped by the user
            browser_type, -- Gets web events grouped by the browser type
            CAST(date_trunc('day', e.event_time) AS DATE) -- Gets web events grouped by the event day
    )
SELECT -- Main SELECT statement to combine old and new event data
    COALESCE(oe.user_id, ne.user_id) AS user_id, -- Select user_id from old events or new events (preferring old events if available)
    COALESCE(oe.browser_type, ne.browser_type) AS browser_type, -- Select browser_type from old events or new events (preferring old events if available)
    CASE
        WHEN oe.dates_active IS NOT NULL AND ne.event_date IS NOT NULL THEN ARRAY [ne.event_date] || oe.dates_active -- Append only if both are not null
        WHEN oe.dates_active IS NOT NULL THEN oe.dates_active -- Keep old dates active value if and new dates are null
        ELSE ARRAY [ne.event_date] -- Otherwise old record is empty and should be replaced with new record
    END AS dates_active,  -- Constructs dates_active array: if old events exist, append new event date; otherwise, just use new event date
    DATE('2022-03-11') AS DATE    -- Set the date for the new record to most recent date
FROM
    old_events oe FULL OUTER JOIN new_events ne ON oe.user_id = ne.user_id  -- To include all old and new events

    ---sample ids to test functionality -233460261, -1718986903, -2147470439