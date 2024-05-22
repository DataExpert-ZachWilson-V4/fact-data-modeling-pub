/* Write a DDL statement to create a hosts_cumulated table, as shown in the fact data modeling day 2 lab. Except for in the homework, you'll be doing it by host, not user_id. */

CREATE TABLE hosts_cumulated (
	host VARCHAR,
	-- track list of active days
	host_activity_datelist ARRAY(DATE),
	-- current date
	date DATE
)
WITH (
	FORMAT = 'PARQUET',
	PARTITIONING = ARRAY['date']
)