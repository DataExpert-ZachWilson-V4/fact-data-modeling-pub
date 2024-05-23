CREATE OR REPLACE TABLE Jaswanthv.user_devices_cumulated
(
	user_id BIGINT,
	browser_type VARCHAR,
	dates_active ARRAY(DATE), -- This is created as Datelist
	date DATE
)
WITH
(
	FORMAT = 'PARQUET',
	Partitioning = ARRAY['date']
)


-- Adding extra comment to force the Autograde program run on all files