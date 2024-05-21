CREATE TABLE bgar.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(date),
    date DATE
)
WITH ( 
    format = 'PARQUET',
    partitioning = ARRAY['date']
)
