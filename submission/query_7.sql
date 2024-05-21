CREATE OR REPLACE TABLE dswills94.host_activity_reduced (
	host VARCHAR,
	--host used in varchar datatype
	metric_name VARCHAR,
	--name of metric
	metric_array ARRAY(INTEGER),
	--an array of metrics to track host metrics
	month_start VARCHAR
	--start month of the metric
)
WITH (
	format = 'PARQUET',
	--table formatting
	partitioning = ARRAY['metric_name','month_start']
	--temporal aspect to easily track host by metric and by month start
)
