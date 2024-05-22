-- Create table host_activity_reduced to track reduced host activity based on metric name by month-year

CREATE OR REPLACE TABLE shruthishridhar.host_activity_reduced (
    host VARCHAR,   -- host name
    metric_name VARCHAR,    -- name of metric tracked
    metric_array ARRAY(INTEGER),    -- values for the metric being tracked
    month_start VARCHAR    -- start of month as string
)
WITH (
    format = 'PARQUET', -- setting data format as PARQUET
    partitioning = ARRAY['metric_name', 'month_start']  -- partitioning this data based on metric name and month_start
)