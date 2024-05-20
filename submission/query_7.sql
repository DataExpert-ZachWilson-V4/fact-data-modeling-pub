--Reduced Host Fact Array DDL (query_7.sql)

create table sanniepatron.host_activity_reduced  (
host varchar, -- Column to store the host identifier, as a variable character string
metric_name varchar, -- Column to store the name of the metric being recorded, as a variable character string
metric_array array(integer),  -- Column to store an array of integer values representing the metric data
month_start varchar -- Column to store the start of the month in a string format
)
wITH (
format = 'PARQUET',
partitioning = array['metric_name', 'month_start']
)