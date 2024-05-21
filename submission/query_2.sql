-- QUERY N.2 

-- User Devices Activity Datelist DDL (query_2.sql)
-- Similarly to what was done in day 2 of the fact data modeling week, 
-- write a DDL statement to create a cumulating user activity table by device.
-- This table will be the result of joining the devices table onto the web_events 
-- table, so that you can get both the user_id and the browser_type

CREATE TABLE vzucher.user_devices_cumulated AS
WITH CombinedData AS (
    SELECT
        we.user_id AS user_id,
        d.browser_type AS browser_type,
        CAST(we.event_time AS DATE) AS event_date -- Converting event_time to date
    FROM
        bootcamp.web_events AS we
    JOIN
        bootcamp.devices AS d ON we.device_id = d.device_id
)

SELECT
    user_id,
    browser_type,
    ARRAY_AGG(DISTINCT event_date) AS dates_active, -- Aggregates all distinct activity dates into an array
    MAX(event_date) AS date -- The latest date of activity
FROM
    CombinedData
GROUP BY
    user_id, browser_type



-- SELECT 
--     we.user_id, 
--     COUNT(DISTINCT we.device_id) AS number_of_devices
-- FROM 
--     bootcamp.web_events AS we
-- GROUP BY 
--     we.user_id
-- ORDER BY 
--     number_of_devices DESC

-- We could also group by device_id on the query above to get the number of devices per user, 
-- Considering the cardinality of devices per user is high, might be interesting to check the number of devices per user