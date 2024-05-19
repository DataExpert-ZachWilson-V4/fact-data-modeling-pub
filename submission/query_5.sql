create or replace table deeptianievarghese22866.hosts_cumulated(
host varchar,
host_activity_datelist array(date),
date date
) with
(format = 'PARQUET', 
partitioning = array['date'])
