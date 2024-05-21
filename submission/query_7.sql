-- Create a table named 'host_activity_reduced' in the 'ningde95' schema
CREATE TABLE IF NOT EXISTS ningde95.host_activity_reduced (
  host VARCHAR,               -- The hostname
  metric_name VARCHAR,        -- The name of the metric being recorded
  metric_array ARRAY(INTEGER),-- An array of integers representing the metric values
  month_start VARCHAR         -- The start of the month as a string (e.g., '2023-01')
)
-- Specify table storage format and partitioning
WITH (
  FORMAT = 'PARQUET',         -- Use the Parquet format for storage
  partitioning = ARRAY['metric_name', 'month_start'] -- Partition the table by 'metric_name' and 'month_start'
)
