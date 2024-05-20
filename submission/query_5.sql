--HW2 query_5
CREATE TABLE hdamerla.hosts_cumulated(
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  date DATE
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)
