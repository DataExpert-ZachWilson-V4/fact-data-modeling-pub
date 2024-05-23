-- The host_activity_reduced table is designed to store reduced monthly activity data for each host.
-- This schema includes four columns:
-- 1. host (VARCHAR): This column stores the name or address of the host.
-- 2. metric_name (VARCHAR): This column stores the name of the metric being tracked (e.g., page views, active users).
-- 3. metric_array (ARRAY(INTEGER)): This column stores an array of integer values representing the daily metric values for the month.
-- 4. month_start (VARCHAR): This column stores the start date of the month in a string format (e.g., '2024-05-01').
-- The table uses the Parquet format for efficient data storage and retrieval. Parquet is a columnar storage format that is optimized for use with big data processing frameworks.
-- Additionally, the table is partitioned by the metric_name and month_start columns. Partitioning improves query performance by allowing the database to scan only relevant partitions based on the metric name and month, thus reducing the amount of data read during queries.


CREATE TABLE IF NOT EXISTS vpsjul8468082.host_activity_reduced (
    host VARCHAR,                      -- The address of the host
    metric_name VARCHAR,               -- The name of the metric being tracked
    metric_array ARRAY(INTEGER),       -- An array of integer values representing the daily metric values for the month
    month_start VARCHAR                -- The start date of the month 
)
WITH (
    FORMAT = 'PARQUET',                -- Specifies the format of the data stored in the table
    partitioning = ARRAY['metric_name', 'month_start']  -- Specifies the fields to partition the data by
)
