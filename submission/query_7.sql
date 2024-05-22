/*-----------------------------------------------------
create a table named host_activity_reduced that tracks
host's activity monthly
*/-----------------------------------------------------
CREATE OR REPLACE TABLE ykshon52797255.host_activity_reduced (
  --host: the host
  host VARCHAR,
  -- metric_name: name of the metric
  metric_name VARCHAR,
  -- metric_array: the measure of metrics in an array that is cumulated
  metric_array ARRAY(INTEGER),
  -- month_start: the date of the month
  month_start VARCHAR
)
WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
  )
