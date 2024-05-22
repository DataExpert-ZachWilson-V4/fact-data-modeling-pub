CREATE OR REPLACE TABLE ebrunt.host_activity_reduced(
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start DATE
)
WITH (
  partitioning = ARRAY[ 'month_start' ]
)
