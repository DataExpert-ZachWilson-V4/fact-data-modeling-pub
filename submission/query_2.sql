-- Create a table named user_devices_cumulated that contains the following columns:
CREATE TABLE user_devices_cumulated (
	user_id BIGINT,
	browser_type VARCHAR,
	-- An array of dates when the user was active
	dates_active ARRAY(DATE),
	date DATE
) WITH (
	format = 'PARQUET',
	partitioning = ARRAY['date']
)