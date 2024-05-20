create or replace table hosts_cumulated
(
  host varchar,
  host_activity array(date),
  date date
)
WITH (
format = 'PARQUET',
partitioning = ARRAY['date']
)
