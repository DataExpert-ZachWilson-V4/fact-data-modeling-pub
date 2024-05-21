--HW2 query_7

CREATE TABLE hdamerla.host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['metric_name', 'month_start']
)
