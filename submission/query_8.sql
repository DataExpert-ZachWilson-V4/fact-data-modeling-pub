-- Insert data into the table host_activity_reduced
INSERT INTO nancyatienno21998.host_activity_reduced
-- Common Table Expressions (CTEs) to gather data for yesterday and today
WITH yesterday AS (
    -- Subquery to get data for yesterday
    SELECT *
    FROM nancyatienno21998.host_activity_reduced
    WHERE month_start = '2023-08-01'
),
today AS (
    -- Subquery to get data for today
    SELECT
        host,
        metric_name,
        metric_value,
        date
    FROM nancyatienno21998.daily_web_metrics
    WHERE Date = CAST('2023-08-02' AS DATE)
)
-- Main query to combine data from yesterday and today
SELECT
    -- Use COALESCE to select non-null values between yesterday and today
    COALESCE(y.host, t.host) AS host,
    COALESCE(y.metric_name, t.metric_name) AS metric_name,
    -- Appending Nulls for each day for metrics that don't appear on month start until they start to show up
    COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
    '2023-08-01' AS month_start
FROM yesterday y
-- Perform a FULL OUTER JOIN to include all hosts from both days
FULL OUTER JOIN today t ON y.host = t.host AND y.metric_name = t.metric_name
