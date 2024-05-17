
-- The query should insert the daily metrics from the `daily_web_metrics` table into the `host_activity_reduced` table.
INSERT INTO luiscoelho37431.host_activity_reduced
WITH yesterday AS (
    -- Select the records from the `host_activity_reduced` table for the previous month
    SELECT *
    FROM luiscoelho37431.host_activity_reduced
    WHERE month_start = '2021-01-01'
),
today AS (
    -- Select the records from the `daily_web_metrics` table for the current date
    SELECT *
    FROM luiscoelho37431.daily_web_metrics
    WHERE date = DATE('2021-01-02')
)
SELECT
    -- Combine the host values from both tables, taking the non-null value
    COALESCE(t.host, y.host) AS host,
    -- Combine the metric_name values from both tables, taking the non-null value
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    -- Combine the metric_array values from both tables, taking the non-null value and appending the current metric_value
    COALESCE(
        y.metric_array, 
        REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2021-01-01'), t.date) AS INTEGER))
    ) || ARRAY[t.metric_value] AS metric_array,
    -- Set the month_start value to '2021-01-01'
    '2021-01-01' AS month_start
FROM today AS t
FULL OUTER JOIN yesterday AS y 
ON t.host = y.host AND t.metric_name = y.metric_name
