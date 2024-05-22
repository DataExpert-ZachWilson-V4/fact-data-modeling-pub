CREATE OR REPLACE TABLE hosts_cumulated
(
    host VARCHAR, 
    host_activity_datelist ARRAY(date),
    date DATE
)
WITH
(  
    format = 'Parquet',
    partitioning = ARRAY['date']
)
