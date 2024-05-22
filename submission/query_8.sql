-- This query inserts data into the 'host_activity_reduced' table by combining data from 'last_host_activity' and 'new_host_activity'
INSERT INTO amaliah21315.host_activity_reduced 
WITH last_host_activity AS ( -- Subquery to select all records from 'host_activity_reduced' for a specific date
    SELECT * FROM amaliah21315.host_activity_reduced
    WHERE month_start = '2023-08-01' -- Filter table for the specific date '2023-08-01'
),
new_host_activity AS (-- Subquery to select all records from 'daily_web_metrics' for a specific date typically new data
    SELECT * FROM amaliah21315.daily_web_metrics
    WHERE DATE = DATE('2023-08-03') -- Filter metrics to only include those from '2023-08-03'
)
-- Main SELECT statement to combine old and new host activity data
SELECT
    COALESCE(nha.host, la.host) AS host, -- Select host from new activity or last activity (preferring new activity if available)
    COALESCE(nha.metric_name, la.metric_name) AS metric_name, -- Select metric name from new activity or last activity (preferring new activity if available)
    COALESCE(
        la.metric_array, -- If the metric array from last activity is not null, use it
        REPEAT( -- Otherwise, create an array of NULL values
            NULL, -- NULL values to fill the array
            CAST(
                DATE_DIFF('day', DATE('2023-08-01'), nha.date) AS INTEGER -- The length of the array is the difference in days between '2023-08-01' and the date of the new activity
            )
        )
    ) || ARRAY [nha.metric_value] AS metric_array, -- Append the new metric value to the existing array
    '2023-08-01' AS month_start -- Set the month start date for the new record to '2023-08-01'
FROM
    new_host_activity nha -- Alias for the new host activity data
    FULL OUTER JOIN last_host_activity la ON nha.host = la.host -- Full Join last and new host data on host
    AND nha.metric_name = la.metric_name -- Full join last amd mew on metric name
