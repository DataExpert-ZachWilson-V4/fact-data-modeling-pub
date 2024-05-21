/*

As shown in fact data modeling day 3 lab, 
write a query to incrementally populate the host_activity_reduced table 
from a daily_web_metrics table. Assume daily_web_metrics exists in your query.
Don't worry about handling the overwrites or deletes for overlapping data.

Remember to leverage a full outer join, 
and to properly handle imputing empty values in the array for windows 
where a host gets a visit in the middle of the array time window.
 Create your own version of daily_web_metrics table
 CREATE OR REPLACE TABLE ameena543246912.daily_web_metrics
(
    host VARCHAR,
    metric_name VARCHAR,
    metric_value INTEGER,
    date DATE

)
with
(
    partitioning = ARRAY['metric_name' , 'date']

)*/

-- Insert data into the 'host_activity_reduced' table
INSERT INTO host_activity_reduced
-- Define a CTE (Common Table Expression) named 'yesterday' to select data from the previous day
WITH yesterday AS (
    SELECT *
    FROM host_activity_reduced
    WHERE month_start = '2023-08-01'  -- Select records where the month_start is August 1, 2023
),
-- Define another CTE named 'today' to select data from the current day
today AS (
    SELECT *
    FROM daily_web_metrics
    WHERE month_start = '2023-08-02'  -- Select records where the month_start is August 2, 2023
)
-- Perform the main query to merge data from 'yesterday' and 'today'
SELECT 
    COALESCE(y.host, t.host) AS host,  -- Use the host from 'yesterday' or 'today', whichever is not NULL
    COALESCE(y.metric_name, t.metric_name) AS metric_name,  -- Use the metric_name from 'yesterday' or 'today', whichever is not NULL
    y.metric_array || ARRAY[t.metric_value] AS metric_array,  -- Append today's metric value to the existing metric array
    '2023-08-01' AS month_start  -- Set the month_start to August 1, 2023
FROM 
    today t FULL OUTER JOIN yesterday y ON 
    t.host = y.host AND t.metric_name = y.metric_name -- Join on the host and metric_name columns
