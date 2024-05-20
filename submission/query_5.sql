-- CUMULATED table of dates active by host

CREATE OR REPLACE TABLE tharwaninitin.hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),		-- array of dates where there was activity from a given host
  date DATE		                            -- current load date
) WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['date']
)