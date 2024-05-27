-- This query creates the host_activity_reduced table to store reduced monthly activity data for each host.

CREATE TABLE IF NOT EXISTS host_activity_reduced (
    host VARCHAR,                      -- Stores the name or address of the host
    metric_name VARCHAR,               -- Stores the name of the metric being tracked (e.g., page views, active users)
    metric_array ARRAY(INTEGER),       -- Stores an array of integer values representing the daily metric values for the month
    month_start VARCHAR                -- Stores the start date of the month in a string format (e.g., '2024-05-01')
)
WITH (
    FORMAT = 'PARQUET',                -- Uses Parquet format for efficient data storage and retrieval
    partitioning = ARRAY['metric_name', 'month_start']  -- Partitions the data by metric_name and month_start for improved query performance
)

-- The table uses the Parquet format for efficient data storage and retrieval.
-- Parquet is a columnar storage format optimized for use with big data processing frameworks.
-- Additionally, the table is partitioned by the metric_name and month_start columns.
-- Partitioning improves query performance by allowing the database to scan only relevant partitions based on the metric name and month,
-- thus reducing the amount of data read during queries.
