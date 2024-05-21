-- Inserts data into the "hosts_cumulated" table combined from web events
INSERT INTO
    amaliah21315.hosts_cumulated WITH old_events AS ( 
        -- Subquery to select all records from "hosts_cumulated" for a specific date
        SELECT
            *
        FROM
            amaliah21315.hosts_cumulated 
        WHERE
            DATE = DATE('2022-03-10') -- Filter table for specific dates cumulation
    ),
    new_events AS (
         -- Subquery to select new event data from "web_events" table
        SELECT
            e.host, -- Hosts name from the web event
            CAST(date_trunc('day', e.event_time) AS DATE) AS event_date -- select the event date excluding the time
        FROM
            bootcamp.web_events e
     WHERE
            date_trunc('day', e.event_time) = DATE('2022-03-11') -- Filter events to only include those that occurred on '2022-03-11
        GROUP BY
            e.host, -- Gets web events grouped by the host
            CAST(date_trunc('day', e.event_time) AS DATE) -- Gets web events grouped by the event day
    )
SELECT -- Main SELECT statement to combine old and new event data
    COALESCE(oe.host, ne.host) AS host, -- Select host from old events or new events (preferring old events if available)
   CASE
        WHEN oe.host_activity_datelist  IS NOT NULL AND ne.event_date IS NOT NULL THEN ARRAY [ne.event_date] || oe.host_activity_datelist  -- Append only if both are not null
        WHEN oe.host_activity_datelist  IS NOT NULL THEN oe.host_activity_datelist  -- Keep old dates active value if and new dates are null
        ELSE ARRAY [ne.event_date] -- Otherwise old record is empty and should be replaced with new record
    END AS host_activity_datelist ,  -- Constructs dates_active array: if old events exist, append new event date; otherwise, just use new event date
    DATE('2022-03-11') AS DATE    -- Set the date for the new record to most recent date
FROM
    old_events oe FULL OUTER JOIN new_events ne ON oe.host = ne.host  -- To include all old and new events
