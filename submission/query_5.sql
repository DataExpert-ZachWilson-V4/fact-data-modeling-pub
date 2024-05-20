--DDL statement to create a hosts_cumulated table
create or REPLACE table vaishnaviaienampudi83291.hosts_cumulated(
    host VARCHAR --name of the host 
    host_activity_datelist ARRAY(DATE) -- datelist array
    date DATE
)
with (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['date']
)
