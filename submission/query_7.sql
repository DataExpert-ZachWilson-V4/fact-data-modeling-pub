CREATE TABLE host_activity_reduced (
-- host activity reduced to store monthly hosts active in a single row
host varchar,
-- metric name based on pages visited
metric_name varchar,
-- number of hosts visisted by day for a given month
metric_array array(integer),
-- month start day snapshot for given month
month_start varchar
)
WITH (
    -- format to store the file in Apache Iceberg
  format = 'PARQUET',
  -- records with same metric_name and month start day will be stored in same file partition
  partitioning = ARRAY['metric_name', 'month_start']
)
 