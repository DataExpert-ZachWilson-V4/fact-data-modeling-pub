CREATE TABLE IF NOT EXISTS hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),  --Array that holds all active dates
  date DATE
)
WITH (
  format = 'parquet',
  partitioning = ARRAY['date']
)
