CREATE TABLE mamontesp.user_devices_cumulated (
	  user_id BIGINT
	, dates_active_by_browser MAP(VARCHAR, ARRAY(DATE))
	, date DATE
)
WITH (
	format = 'PARQUET'
	, partitioning = ARRAY['date']
)