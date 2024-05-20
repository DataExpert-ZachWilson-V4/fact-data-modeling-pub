--quick intro: a reduced fact data table with 1 row per month per host per metric
CREATE OR REPLACE TABLE derekleung.host_metrics_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
)
WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
  )
