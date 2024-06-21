-- delete from jlcharbneau.user_devices_cumulated
-- select * from jlcharbneau.user_devices_cumulated

INSERT INTO user_devices_cumulated
WITH yesterday AS (
    SELECT *
    FROM user_devices_cumulated
    WHERE date = DATE '2021-02-04'  -- Last updated date
    ),

-- The 'today' CTE processes new activities from the web events, targeting the day immediately after 'yesterday'.
-- It groups data by 'user_id' and 'browser_type' and collects distinct active dates.
    today AS (
SELECT
    we.user_id,
    d.browser_type,
    ARRAY_AGG(DISTINCT DATE_TRUNC('day', we.event_time)) AS dates_active
FROM
    bootcamp.devices d
    JOIN bootcamp.web_events we ON d.device_id = we.device_id
WHERE DATE_TRUNC('day', we.event_time) = DATE '2021-02-05'  -- The next day after the last update
GROUP BY
    we.user_id, d.browser_type
    )

-- Insert updated data into the cumulative table, merging 'yesterday' and 'today' data.
-- This step ensures that all user activities are accurately recorded and no data is lost between updates.

SELECT
    -- Use COALESCE to handle any null values by choosing data from 'today' if available, otherwise from 'yesterday'.
    COALESCE(yesterday.user_id, today.user_id) AS user_id,
    COALESCE(yesterday.browser_type, today.browser_type) AS browser_type,

    -- Merge and deduplicate date arrays from 'yesterday' and 'today' using the concat function and array_distinct.
    -- This ensures all unique activity dates are captured in the cumulative table.
    array_distinct(concat(COALESCE(yesterday.dates_active, ARRAY[]), COALESCE(today.dates_active, ARRAY[]))) AS dates_active,

    DATE('2021-02-05') AS date  -- Record the date of update to track when the last update occurred.
FROM
    yesterday
    FULL OUTER JOIN today
ON yesterday.user_id = today.user_id
    AND yesterday.browser_type = today.browser_type