-- query_7
CREATE OR REPLACE TABLE host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
) WITH (
  format = 'PARQUET',
  partitioning = ARRAY['metric_name', 'month_start']
)
