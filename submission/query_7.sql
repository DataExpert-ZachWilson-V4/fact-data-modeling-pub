-- A table to store the reduced data about the host activity
CREATE TABLE host_activity_reduced (
	host VARCHAR,
	-- What metric are we storing
	metric_name VARCHAR,
	-- The metric data across 'n' days
	metric_array ARRAY(INTEGER),
	month_start VARCHAR
) WITH (
	format = 'PARQUET',
	partitioning = ARRAY['metric_name', 'month_start']
	
)