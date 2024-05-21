create or replace table
deeptianievarghese22866.host_activity_reduced(
host varchar,
metric_name varchar,
metric_array array(integer),
month_start varchar
)with
(format = 'PARQUET', 
partitioning = array['month_start'])

