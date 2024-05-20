-- Create or replace the table host_activity_reduced
CREATE OR REPLACE TABLE nonasj.host_activity_reduced (

    -- The host identifier
    host VARCHAR,

    -- The name of the metric
    metric_name VARCHAR,

    -- Array of integers representing the metric values
    metric_array ARRAY(INTEGER),

    -- The start of the month in 'YYYY-MM' format
    month_start VARCHAR
)
WITH (
    -- Specify the file format for the table
    FORMAT = 'PARQUET',

    -- Partition the table by the month_start column for performance optimization
    partitioning = ARRAY['metric_name','month_start']
)
