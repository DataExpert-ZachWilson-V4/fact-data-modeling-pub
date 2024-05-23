-- Create or replace the table halloweex.hosts_cumulated
CREATE OR REPLACE TABLE halloweex.hosts_cumulated (
    -- Column to store the host name
    host VARCHAR,
    -- Column to store an array of dates representing the host activity
    host_activity_datelist ARRAY(DATE),
    -- Column to store the date
    date DATE
)
-- Table properties
WITH (
    -- Specify the storage format as PARQUET
    format = 'PARQUET',
    -- Specify the partitioning column as date
    partitioning = ARRAY['date']
)