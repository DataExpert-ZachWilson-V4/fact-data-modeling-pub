--Cumulated table of activity dates by host
CREATE OR REPLACE TABLE hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),		--Array of dates where there was activity from a given host
  date DATE		--Current date - used for partitioning
) WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['date']
)