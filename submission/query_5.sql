CREATE OR REPLACE TABLE ykshon52797255.hosts_cumulated (
  host VARCHAR,
  host_activity_datelist array(date),
  date date
)

WITH (
  format = 'PARQUET',
  PARTITIONING = ARRAY['date']
)
