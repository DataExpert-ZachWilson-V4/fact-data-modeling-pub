-- DDL statement to create a monthly host_activity_reduced table
CREATE OR REPLACE TABLE positivelyamber.host_activity_reduced(
    -- Name of the host
    host VARCHAR,
    -- The metric being measured 
    metric_name VARCHAR,
    -- List of the dates the host had activity 
    metric_array ARRAY(INTEGER),
    -- The month we are starting with
    month_start VARCHAR,
)
WITH (
    -- Parquet formatting
    format = 'PARQUET',
    -- Partition by date
    partitioning = ARRAY['metric_name', 'month_start']
)