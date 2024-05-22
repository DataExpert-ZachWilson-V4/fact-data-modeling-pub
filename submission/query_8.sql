INSERT INTO halloweex.host_activity_reduced
WITH
    -- CTE to select data from the host_activity_reduced table for a specific month
    yesterday AS (SELECT *
                  FROM halloweex.host_activity_reduced
                  WHERE month_start = '2023-08-01'),

    -- CTE to select data from the daily_web_metrics table for a specific date
    today AS (SELECT *
              FROM halloweex.daily_web_metrics
              WHERE event_time = DATE '2023-08-03')

-- Main SELECT statement to combine data from yesterday and today CTEs
SELECT
    -- Use COALESCE to handle NULL values, preferring today's data first
    COALESCE(t.host, y.host)               AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,

    -- Handle the case where y.metric_array is NULL
    CASE
        WHEN y.metric_array IS NOT NULL THEN y.metric_array
        ELSE ARRAY_REPEAT(CAST(NULL AS INTEGER), CAST(DATE_DIFF('day', DATE '2023-08-01', t.event_time) AS INTEGER))
        END || ARRAY[t.metric_value]       AS metric_array,

    -- Set the month_start column to the specific date
    '2023-08-01'                           AS month_start

-- Join the today and yesterday CTEs using FULL OUTER JOIN to ensure all rows are included
FROM today t
         FULL OUTER JOIN yesterday y ON t.host = y.host AND t.metric_name = y.metric_name
