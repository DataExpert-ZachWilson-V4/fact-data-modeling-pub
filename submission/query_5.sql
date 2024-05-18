CREATE TABLE jrsarrat.hosts_cumulated (
  host VARCHAR,
  host_activity_datelist array(DATE),
  date DATE
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
