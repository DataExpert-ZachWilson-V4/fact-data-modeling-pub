-- SQL DDL to create a table for reduced host activity metrics.
-- This table is designed to store monthly reduced metrics for each host.

CREATE OR REPLACE TABLE host_activity_reduced (
    host VARCHAR,                          -- Stores the host identifier, typically a string.
    metric_name VARCHAR,                   -- The name of the metric being tracked.
    metric_array ARRAY(INTEGER),           -- An array of integers representing the metric values for the month.
    month_start VARCHAR                    -- The start of the month in 'YYYY-MM' format to denote the period.
) WITH (
    FORMAT = 'PARQUET',                    -- Specifies the storage format; PARQUET is chosen for efficient storage.
    PARTITIONING = ARRAY['metric_name', 'month_start']  -- Partitions the table by the 'metric_name' and 'month_start' columns for better query performance.
)