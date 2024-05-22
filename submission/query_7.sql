--As shown in the fact data modeling day 3 lab, write a DDL statement to create a monthly host_activity_reduced table, 
--containing the following fields:
--host varchar
--metric_name varchar
--metric_array array(integer)
--month_start varchar

CREATE OR REPLACE TABLE saidaggupati.host_activity_reduced (
  host VARCHAR,        
  metric_name VARCHAR,        
  metric_array ARRAY(INTEGER),    
  month_start VARCHAR             
)
WITH
(
  FORMAT = 'PARQUET',
  partitioning = ARRAY['metric_name','month_start']
)

 
 
