-- Create or replace a table called 'hosts_cumulated'
-- This table will store cumulative data for hosts

CREATE OR REPLACE TABLE luiscoelho37431.hosts_cumulated (
    host VARCHAR,
    
    -- Define a column named 'host_activity_datelist' of type ARRAY<DATE>
    -- This column will store an array of dates representing host activity
    host_activity_datelist ARRAY<DATE>,
    date DATE
) WITH (
    -- Specify the format of the table as 'PARQUET'
    format = 'PARQUET',
    
    -- Specify the partitioning scheme for the table
    -- The table will be partitioned based on the 'date' column
    partitioning = ARRAY['date']
)