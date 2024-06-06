
-- Create the `host_activity_reduced` table
CREATE TABLE host_activity_reduced (
    host VARCHAR, -- The host name
    metric_name VARCHAR, -- The name of the metric
    metric_array array(INTEGER), -- An array of metric values
    month_start VARCHAR -- The start month of the data
)
WITH
    (
        FORMAT = 'PARQUET', -- Store the data in Parquet format
        partitioning = ARRAY['metric_name', 'month_start'] -- Partition the data by metric name and month start
    )
