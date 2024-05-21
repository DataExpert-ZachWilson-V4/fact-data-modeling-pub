-- Reduced Host Fact Array DDL (query_7.sql)
-- This DDL statement creates a monthly host_activity_reduced table to store reduced host activity data.

-- Create the host_activity_reduced table
CREATE TABLE host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
) WITH (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
)
