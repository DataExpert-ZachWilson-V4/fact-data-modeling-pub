CREATE TABLE jrsarrat.host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array array(INTEGER),
  month_start VARCHAR
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['metric_array'])
