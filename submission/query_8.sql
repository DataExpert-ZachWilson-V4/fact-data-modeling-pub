-- This query incrementally populates the host_activity_reduced table by merging new daily web metrics data with the existing reduced monthly data.

INSERT INTO iliamokhtarian.host_activity_reduced
WITH 
    -- Define a CTE (Common Table Expression) for yesterday's data
    -- The yesterday CTE retrieves the records from `host_activity_reduced` for the previous month (2022-12-01).
    yesterday AS (
        SELECT *
        FROM iliamokhtarian.host_activity_reduced
        WHERE month_start = '2022-12-01'  -- Assuming '2022-12-01' is the previous month's start date
    ),

    -- Define a CTE for today's data
    -- The today CTE extracts the relevant data from the daily_web_metrics table for today's date (2022-12-21).
    today AS (
        SELECT 
            host,                             -- Host column from the daily_web_metrics table
            metric_name,                      -- Name of the metric being tracked
            metric_value,                     -- Value of the metric for today
            DATE                              -- Date of the metric value
        FROM iliamokhtarian.daily_web_metrics
        WHERE DATE = DATE('2022-12-21')       -- Assuming '2022-12-21' is today's date
    )

-- Merge yesterday's data with today's data and insert into host_activity_reduced
SELECT 
    COALESCE(t.host, y.host) AS host,                        -- Take the non-null host value from either yesterday or today
    COALESCE(t.metric_name, y.metric_name) AS metric_name,   -- Take the non-null metric_name value from either yesterday or today
    COALESCE(
        y.metric_array,                                      -- If previous data exists, use the existing metric_array
        REPEAT(                                              -- If no previous data, create a new array with NULL values for the days up to the current date
            NULL,
            CAST(
                DATE_DIFF('day', DATE('2022-12-21'), t.date) AS INTEGER
            )
        )
    ) || ARRAY[t.metric_value] AS metric_array,             -- Append the current metric_value to the metric_array
    '2023-01-01' AS month_start                             -- Set the month_start column to the first day of the current month
FROM 
    today t
    FULL OUTER JOIN yesterday y ON t.host = y.host          -- Join yesterday's and today's data based on the host
    AND t.metric_name = y.metric_name                       -- and metric_name
