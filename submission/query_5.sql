CREATE TABLE dataste0.hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  date DATE
) WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)