-- Creates a table of reduced cumilated hosts
CREATE
OR REPLACE TABLE amaliah21315.host_activity_reduced (
  host VARCHAR, -- Host name variable
  metric_name VARCHAR, --Name of metric
  metric_array ARRAY (INTEGER), --Column to record an array of metrics
  month_start VARCHAR -- Column to store the character start of the record
)
WITH
  (
    FORMAT = 'PARQUET', -- Stores data in PARQUET format
    partitioning = ARRAY['metric_name','month_start'] -- Partitions the table by the metric_name and "month_start" column
  )