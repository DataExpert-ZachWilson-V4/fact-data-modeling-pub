-- Create a table hosts_cumulated that contains the following columns:
CREATE TABLE hosts_cumulated (
	-- The host name
	host VARCHAR,
	-- Dates when the host was active i.e. someone visited this host
	host_activity_datelist ARRAY(DATE),
	date DATE
) WITH (
	format = 'PARQUET',
	partitioning = ARRAY['date']
)