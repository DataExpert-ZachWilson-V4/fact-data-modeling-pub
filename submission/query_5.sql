-- Host Activity Datelist DDL (query_5.sql)
-- This DDL statement creates a hosts_cumulated table to track host activity by date.

-- Create the hosts_cumulated table
CREATE TABLE alissabdeltoro.hosts_cumulated (
    host VARCHAR,  -- Hostname or IP address of the host
    host_activity_datelist ARRAY(DATE),  -- Array to store activity dates
    date DATE  -- Date for partitioning
) WITH (
    FORMAT = 'PARQUET',  -- Parquet format for optimized storage
    partitioning = ARRAY['date']  -- Partitioning by date for efficient querying
)
