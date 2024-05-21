-- QUERY N.3

-- User Devices Activity Datelist Implementation (query_3.sql)
-- Write the incremental query to populate the table you wrote the DDL for in the above 
-- question from the web_events and devices tables. This should look like the query to generate the cumulation table from the fact modeling day 2 lab.
-- Assumption: We have a timestamp or a mechanism to track the last update


-- The NewEventData CTE selects new event data from the web_events table
-- The ExistingData CTE selects the existing current data from the user_devices_cumulated table,
-- The AggregatedNewData CTE aggregates the new data so that we can join it with the existing data,
-- The DistinctDates CTE selects data from ExistingData and AggregatedNewData CTEs and unions them together, but only the distinct dates,
-- The ReaggregatedDates CTE aggregates the distinct dates and finds the latest date for each user and browser type,

WITH NewEventData AS (
    SELECT
        we.user_id,
        d.browser_type,
        CAST(we.event_time AS DATE) AS event_date
    FROM
        bootcamp.web_events AS we
    JOIN
        bootcamp.devices AS d ON we.device_id = d.device_id
    WHERE
        we.event_time > (SELECT MAX(date) FROM vzucher.user_devices_cumulated) -- Only select events newer than the latest in the cumulation table
),
ExistingData AS (
    SELECT
        user_id,
        browser_type,
        dates_active,
        (SELECT MAX(date) FROM UNNEST(dates_active) AS date) AS latest_date -- Computes the latest date from the existing active dates
    FROM
        vzucher.user_devices_cumulated
),
AggregatedNewData AS (
    SELECT
        n.user_id,
        n.browser_type,
        ARRAY_AGG(DISTINCT n.event_date) AS new_dates_active,
        MAX(n.event_date) AS new_date
    FROM
        NewEventData n
    GROUP BY
        n.user_id, n.browser_type
),
DistinctDates AS (
    SELECT
        user_id,
        browser_type,
        date
    FROM
        ExistingData
    CROSS JOIN UNNEST(dates_active) AS t(date)
    UNION
    SELECT
        user_id,
        browser_type,
        date
    FROM
        AggregatedNewData
    CROSS JOIN UNNEST(new_dates_active) AS t(date)
),
ReaggregatedDates AS (
    SELECT
        user_id,
        browser_type,
        ARRAY_AGG(DISTINCT date) AS dates_active,  -- Aggregate distinct dates into an array
        MAX(date) AS date  -- Find the latest date from the aggregated distinct dates
    FROM
        DistinctDates
    GROUP BY
        user_id, browser_type
)
SELECT
    user_id,
    browser_type,
    dates_active,
    date
FROM
    ReaggregatedDates
