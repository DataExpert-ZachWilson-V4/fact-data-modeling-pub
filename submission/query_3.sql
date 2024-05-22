-- Insert new data into the user_devices_cumulated table
INSERT INTO raniasalzahrani.user_devices_cumulated
WITH
    -- Retrieve all records from the user_devices_cumulated table for the previous day
    yesterday AS (
        SELECT
            *
        FROM
            raniasalzahrani.user_devices_cumulated
        WHERE
            date = DATE('2023-01-04')
    ),
    -- Fetch current day activity from web_events and devices tables
    today AS (
        SELECT
            we.user_id,  -- Select user_id from web_events table
            de.browser_type,  -- Select browser_type from devices table
            CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,  -- Convert event_time to event_date
            DATE('2023-01-05') AS date  -- Set the date to 2023-01-05
        FROM
            bootcamp.web_events we
        INNER JOIN bootcamp.devices de ON we.device_id = de.device_id  -- Join web_events and devices tables on device_id
        WHERE
            date_trunc('day', we.event_time) = DATE('2023-01-05')  -- Filter for events on 2023-01-05
        GROUP BY
            we.user_id,
            de.browser_type,
            event_time,
            CAST(date_trunc('day', we.event_time) AS DATE)  -- Group by user_id, browser_type, event_time, and event_date
    )
-- Combine yesterday's and today's records, ensuring all combinations are included
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,  -- Use user_id from today if available, otherwise from yesterday
    COALESCE(y.browser_type, t.browser_type) AS browser_type,  -- Use browser_type from today if available, otherwise from yesterday
    -- Update dates_active by adding today's date to the existing array if it exists
    CASE
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    DATE('2023-01-05') AS date  -- Set the date to the current date
FROM
    yesterday y
FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type  -- Perform a full outer join on user_id and browser_type
