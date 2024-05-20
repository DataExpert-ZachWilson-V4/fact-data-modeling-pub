create or replace table abhishekshetty.host_activity_reduced
(
  host varchar,
  metric_name varchar,
  metric_array array(integer),
  month_start varchar
)
WITH (
format = 'PARQUET',
partitioning = ARRAY['month_start', 'metric_name']
)
