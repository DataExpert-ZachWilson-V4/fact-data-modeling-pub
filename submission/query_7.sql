-- Creating a reduced table for calculating aggregated metrics by keeping track of first day of month and
-- expanding metric array as needed to get the required data
CREATE OR REPLACE TABLE pratzo.host_activity_reduced (
  host VARCHAR,                  
  metric_name VARCHAR,            
  metric_array ARRAY(INTEGER),    -- Array of metric values
  month_start VARCHAR             -- Start date of the month
)
WITH
(
  FORMAT = 'PARQUET',                     
  partitioning = ARRAY['metric_name', 'month_start']   -- Will be queriying on metric name and month start
)