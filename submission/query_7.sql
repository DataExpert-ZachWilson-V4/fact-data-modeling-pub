-- query_7 Reduced Host Fact Array DDL
-- Creating a reduced table for calculating aggregated metrics by keeping track of first day of month and
-- expanding metric array as needed to get the required data
-- This DDL statement creates a monthly host_activity_reduced table to store reduced host activity data

CREATE OR REPLACE TABLE aayushi.host_activity_reduced (
    host VARCHAR                    -- Host name
  , metric_name VARCHAR             -- Name of the metric
  , metric_array ARRAY(INTEGER)     -- Array of metric values
  , month_start VARCHAR             -- Start month of the metric data
)
WITH
(
    FORMAT = 'PARQUET'                                  -- Storage format is Parquet by default
  , partitioning = ARRAY['metric_name', 'month_start']  -- Partitioned by 'metric_name' column and 'month_start' column
)