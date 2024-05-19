-- Create or replace a table named host_activity_reduced
CREATE
OR REPLACE TABLE RaviT.host_activity_reduced (
  host varchar,
  metric_name varchar,
  metric_array array(integer), -- Column to store an array of metrics as integers
  month_start varchar
)
WITH
  (
    FORMAT = 'PARQUET', -- Store the table in Parquet format
    partitioning = ARRAY['metric_name', 'month_start'] -- Partition the table by metric_name and month_start
  )
