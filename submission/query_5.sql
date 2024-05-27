create
or replace table sanchit.hosts_cumulated (
  host varchar,
  host_activity_datelist array(date),
  date date
)
with
  (format = 'parquet', partitioning = array['date'])
