-- Create or replace the table halloweex.host_activity_reduced
CREATE OR REPLACE TABLE halloweex.host_activity_reduced (
    -- Column to store the host name
    host VARCHAR,
    -- Column to store the name of the metric
    metric_name VARCHAR,
    -- Column to store an array of integer metric values
    metric_array ARRAY(INTEGER),
    -- Column to store the start of the month (in string format)
    month_start VARCHAR
)
-- Table properties
WITH (
    -- Specify the storage format as PARQUET
    format = 'PARQUET',
    -- Specify the partitioning columns as metric_name and month_start
    partitioning = ARRAY['metric_name', 'month_start']
)