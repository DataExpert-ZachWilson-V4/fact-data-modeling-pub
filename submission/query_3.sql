/* User Devices Activity Datelist Implementation (query_3.sql)

Write the incremental query to populate the table you wrote the DDL
for in the above question from the web_events and devices tables. 
This should look like the query to generate the cumulation table from 
the fact modeling day 2 lab.
*/
INSERT INTO danieldavid.user_devices_cumulated
-- 1) Start: pull user_devices_cumulated from yesterday to use as a starting point
WITH yesterday AS (
    SELECT *
    FROM danieldavid.user_devices_cumulated
    -- parameterize to improve: hardcoded yesterday's date
    WHERE date = DATE('2023-01-01')
),
-- 2) Stage: clean today's data to match target user_devices_cumulated schema
today AS (
    SELECT
        we.user_id,
        d.browser_type,
        -- remove time from event_time to event_date
        CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date
    FROM 
        bootcamp.web_events we
        LEFT JOIN bootcamp.devices d 
        ON we.device_id = d.device_id
    WHERE 
        -- parameterize to improve: hardcoded today's date
        CAST(DATE_TRUNC('day', we.event_time) AS DATE) = DATE('2023-01-02')
    GROUP BY
        we.user_id,
        d.browser_type,
        CAST(DATE_TRUNC('day', we.event_time) AS DATE)
)
-- 3) Cumulate: join yesterday and today to cumulate table
    -- a) dates_active: array of dates user is active
SELECT 
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    -- a) dates_active 
    -- if yesterday's dates_active is not null, append today's event_date to the first index
    -- else, create a new array with today's event_date
    CASE WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    -- parameterize to improve: hardcoded today's date
    DATE('2023-01-02') AS date
FROM 
    yesterday y
    FULL OUTER JOIN today t 
    ON y.user_id = t.user_id AND y.browser_type = t.browser_type