CREATE
OR REPLACE TABLE rgindallas.host_activity_reduced (
  host varchar,
  metric_name varchar,
  metric_array array(integer),
  month_start DATE
)
WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
  )
