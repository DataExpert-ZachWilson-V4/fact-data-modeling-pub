CREATE TABLE monthly_host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)

WITH
  (
    FORMAT = 'PARQUET',
    -- Partition the table by 'metric_name' and 'month_start' for improved query performance
    partitioning = ARRAY['metric_name', 'month_start']
  )
