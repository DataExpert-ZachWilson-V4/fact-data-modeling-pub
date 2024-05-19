CREATE OR REPLACE TABLE nancycast01.host_activity_reduced (

  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER), -- datelist that tracks how many times a host has been active
  month_start VARCHAR
)

WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name','month_start']
  )
