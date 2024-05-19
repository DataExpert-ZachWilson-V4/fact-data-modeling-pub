-- Create or replace the table hosts_cumulated
CREATE OR REPLACE TABLE raj.hosts_cumulated (
    
    -- The host identifier
    host VARCHAR,  
    
    -- Array of dates when the host was active
    host_activity_datelist ARRAY(DATE),
    
    -- The date of the record (used for partitioning)
    date DATE
)
WITH (
    -- Specify the file format for the table
    FORMAT = 'PARQUET',
    
    -- Partition the table by the date column for performance optimization
    partitioning = ARRAY['date']
)
