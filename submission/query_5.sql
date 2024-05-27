--Again very straightforward, host is the major identifier here
CREATE OR REPLACE TABLE derekleung.hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
