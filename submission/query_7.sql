create
or replace table sanchit.host_activity_reduced (
  host varchar,
  metric_name varchar,
  metric_array array(integer),
  month_start varchar
)
with
  (
    format = 'parquet',
    partitioning = array['metric_name', 'month_start']
  )
