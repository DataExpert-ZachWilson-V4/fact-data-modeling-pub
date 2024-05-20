--DDL statement to create a monthly host_activity_reduced table
create or replace table vaishnaviaienampudi83291.host_activity_reduced(
    host VARCHAR, --name of the host
    metric_name VARCHAR, -- metric name we want to tract
    metric_array ARRAY(INTEGER), 
    month_start VARCHAR 
)
WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
  )
