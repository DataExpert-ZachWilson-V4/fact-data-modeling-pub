-- Create the saismail.host_activity_reduced table
CREATE
OR REPLACE TABLE saismail.host_activity_reduced (
  host VARCHAR, 
  metric_name VARCHAR, 
  metric_array ARRAY(INTEGER), 
  month_start VARCHAR 
)
WITH
  (
    FORMAT = 'PARQUET', 
    partitioning = ARRAY['month_start'] 
  )