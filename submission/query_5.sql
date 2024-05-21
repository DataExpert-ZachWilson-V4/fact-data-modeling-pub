-- Create a table named 'hosts_cumulated' in the schema 'martinaandrulli'
CREATE OR REPLACE TABLE martinaandrulli.hosts_cumulated (
    host VARCHAR,
    -- This columns is used to store an array of dates representing host activity
    host_activity_datelist ARRAY<DATE>, 
    date DATE
) 
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['date']
)