CREATE OR REPLACE TABLE Jaswanthv.host_activity_reduced(
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
  ) WITH
  (
    FORMAT = 'PARQUET',
    Partitioning = ARRAY['metric_name','month_start']
  )
  
  
-- Adding extra comment to force the Autograde program run on all files  