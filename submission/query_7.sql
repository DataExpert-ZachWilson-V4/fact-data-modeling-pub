CREATE TABLE nikhilsahni.host_activity_reduced (
  -- Column to store user IDs
  user_id BIGINT,
  -- Column to store the name of the metric
  metric_name VARCHAR,
  -- Column to store an array of integers representing metric values
  metric_array ARRAY(INTEGER),
  -- Column to store the start of the month as a string
  month_start VARCHAR
)
WITH
  (
    -- Specify the format of the table as Parquet for efficient storage and retrieval
    FORMAT = 'PARQUET',
    -- Partition the table by 'metric_name' and 'month_start' for improved query performance
    partitioning = ARRAY['metric_name', 'month_start']
  )
