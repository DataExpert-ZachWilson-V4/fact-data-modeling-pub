CREATE TABLE IF NOT EXISTS host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),  -- Array that holds all metric values for a specific metric
  month_start VARCHAR
)
WITH (
  format = 'parquet',
  partitioning = ARRAY['metric_name', 'month_start']
)
