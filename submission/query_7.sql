CREATE TABLE host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
)
WITH (
  format = 'parquet',
  partitioning = ARRAY['metric_name', 'month_start']
)
