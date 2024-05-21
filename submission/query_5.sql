CREATE OR REPLACE TABLE dswills94.hosts_cumulated (--we're building DDL for host cumulation table
host VARCHAR,
--host used in varchar datatype 
host_activity_datelist ARRAY(DATE),
--Array of dates to track how many times a host was active 
date DATE
--current date
)
WITH (
format = 'PARQUET',
--table formatting
partitioning = ARRAY['date']
--temporal aspect to easily track changes by date
)
