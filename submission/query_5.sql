-- DDL statement to create a hosts_cumulated table
CREATE OR REPLACE TABLE positivelyamber.hosts_cumulated (
    -- Name of the host
    host VARCHAR,
    -- List of the dates the host had activity 
    host_activity_datelist ARRAY(DATE),
    date DATE
)
WITH (
    -- Parquet formatting
    format = 'PARQUET',
    -- Partition by date
    partitioning = ARRAY['date']
)