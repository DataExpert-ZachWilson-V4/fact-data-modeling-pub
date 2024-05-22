--HW2 query_7
/*a DDL statement to create a monthly host_activity_reduced table */

CREATE or REPLACE TABLE host_activity_reduced ( --ddl based on the requirements
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER), --defining array 
  month_start VARCHAR
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['metric_name', 'month_start']
)
