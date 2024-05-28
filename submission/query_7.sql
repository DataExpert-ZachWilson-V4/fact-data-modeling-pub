-- Reduced Host Fact Array DDL 

CREATE
OR REPLACE TABLE hariomnayani88482.host_activity_reduced (
  host varchar,
  metric_name varchar,
  metric_array array(integer),
  month_start varchar
)
WITH
  (
    FORMAT = 'parquet',
    partitioning = ARRAY['metric_name', 'month_start']
  )