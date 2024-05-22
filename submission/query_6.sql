-- Insert the resulting data into the hosts_cumulated table
INSERT INTO halloweex.hosts_cumulated
WITH
    -- Select all records from hosts_cumulated for the given date
    yesterday AS (
        SELECT
           *
        FROM
            halloweex.hosts_cumulated
        WHERE
            date = DATE '2023-01-01'
    ),
    -- Select distinct hosts and their activity dates from web_events for the given date
    today AS (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS host_activity_datelist
        FROM
            academy.bootcamp.web_events
        WHERE
            date_trunc('day', event_time) = DATE '2023-01-02'
        GROUP BY
            host,
            CAST(date_trunc('day', event_time) AS DATE)
    ),
    -- Combine yesterday's and today's data
    combined AS (
        SELECT
            COALESCE(y.host, t.host) AS host,  -- Use COALESCE to handle missing hosts
            CASE
                -- Combine activity date lists from yesterday and today
                WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
                ELSE ARRAY[t.host_activity_datelist]
            END AS host_activity_datelist,
            DATE '2023-01-02' AS date  -- Set the date for the combined data
        FROM
            yesterday y
        FULL OUTER JOIN today t ON y.host = t.host  -- Perform a full outer join on host
    )
-- Select all columns from the combined data
SELECT
    *
FROM
    combined