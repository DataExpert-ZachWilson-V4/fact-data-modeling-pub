-- Create table hosts_cumulated to store cumulative host activity by browser_type

CREATE OR REPLACE TABLE shruthishridhar.hosts_cumulated (
    host VARCHAR,   -- host identifier
    host_activity_datelist ARRAY(DATE), -- dates of activity for current host
    date DATE   -- current date of host activity
)
WITH (
    format = 'PARQUET', -- setting data format as PARQUET
    partitioning = ARRAY['date']  -- partitioning this data based on date
)