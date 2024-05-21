CREATE OR REPLACE TABLE crouton.hosts_cumulated
(
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  date Date
)
WITH
(
  FORMAT = 'PARQUET',
  partitioning = ARRAY['date'] 
)