--- Create table host_activity_reduced
CREATE TABLE mamontesp.host_activity_reduced (
	host VARCHAR
	, metric_name VARCHAR
	, metric_array ARRAY(INTEGER)
	, month_start DATE
)

WITH (
format = 'PARQUET'
, partitioning = ARRAY['month_start']
)