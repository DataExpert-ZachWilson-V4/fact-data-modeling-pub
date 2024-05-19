-- Reduced Host Fact Array Implementation (query_8.sql)
-- This query incrementally populates the host_activity_reduced table from daily_web_metrics.

-- Retrieve data for the previous month from host_activity_reduced
WITH yesterday AS (
    SELECT * 
    FROM alissabdeltoro.host_activity_reduced
    WHERE month_start = '2023-08-01'  -- Filter data for the previous month
),

-- Retrieve data for the current month from daily_web_metrics
today AS (
    SELECT *
    FROM alissabdeltoro.daily_web_metrics
    WHERE month_start = DATE '2023-08-01'  -- Filter data for the current month
)

-- Select fields for incremental population
SELECT 
    COALESCE(t.host, y.host) AS host,  -- Use the current month's host if available, otherwise, use the previous month's host
    COALESCE(t.metric_name, y.metric_name) AS metric_name,  -- Use the current month's metric name if available, otherwise, use the previous month's metric name
    COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE '2023-08-01', t.date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array  -- Merge the metric arrays from both months
FROM today t
FULL OUTER JOIN yesterday y
    ON t.host = y.host AND t.metric_name = y.metric_name  -- Perform a full outer join to merge data from both months
