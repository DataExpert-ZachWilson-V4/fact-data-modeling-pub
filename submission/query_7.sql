-- Create a monthly reduced fact table `host_activity_reduced`
-- It will store each metric per day for a given month in one array `metric_array`
-- Order of days in the array is in ascending order, meaning first index will be first day of that month, 2nd index - 2nd day and so on
CREATE OR REPLACE TABLE shashankkongara.host_activity_reduced (
    host VARCHAR,  -- Column to store the host name
    metric_name VARCHAR, -- Column to store the metric name
    metric_array ARRAY(INTEGER), -- Column to store an array of integers representing metrics
    month_start VARCHAR --  Use this to partition by month
)
WITH (
    -- Storing data in Parquet Format for efficiency
    FORMAT = 'PARQUET',
    -- Partitioning the table by 'metric_name' & `month_start` for optimized queries and quick data retrieval
    partitioning = ARRAY['metric_name', 'month_start']
);
