-- Insert data into the table hosts_cumulated
INSERT INTO hosts_cumulated
-- Common Table Expressions (CTEs) to gather data for yesterday and today
WITH
    -- Subquery to get data for yesterday
    yesterday AS (
        SELECT
            *
        FROM
            hosts_cumulated
        WHERE
            date = DATE('2023-01-01')
    ),
    -- Subquery to get data for today
    today AS (
        SELECT 
            host,
            CAST(date_trunc('day', event_time) AS DATE) as event_date,
            COUNT(1)
        FROM 
            bootcamp.web_events
        WHERE
            date_trunc('day', event_time) = DATE('2023-01-02')
        GROUP BY
            host,
            CAST(date_trunc('day', event_time) AS DATE)
    )
-- Main query to combine data from yesterday and today
SELECT
    -- Use COALESCE to select non-null values between yesterday and today
    COALESCE(y.host, t.host) AS host,
    -- Use CASE statement to handle NULL values in host_activity_datelist
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN CONCAT(ARRAY[t.event_date], y.host_activity_datelist)
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    -- Set the date value
    DATE('2023-01-01') AS date
FROM
    yesterday AS y
    -- Perform a FULL OUTER JOIN to include all hosts from both days
    FULL OUTER JOIN today AS t ON t.host = y.host
