-- 
CREATE TABLE hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  date DATE
)
WITH (
  format = 'parquet',
  partitioning = ARRAY['date']
)
