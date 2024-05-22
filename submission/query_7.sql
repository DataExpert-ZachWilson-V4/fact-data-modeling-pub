/* Write a DDL statement to create a monthly host_activity_reduced table */

CREATE TABLE host_activity_reduced (
	host VARCHAR,
	-- track metric name by visited pages 
	metric_name VARCHAR,
	-- track count of hosts per day 
	metric_array ARRAY(INTEGER),
	-- track month start value for current month
	month_start varchar
)
WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['metric_name', 'month_start']
)