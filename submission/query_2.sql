-- Create or replace the table 'user_devices_cumulated'
CREATE OR REPLACE TABLE luiscoelho37431.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    -- Column to store an array of active dates
    dates_active ARRAY<DATE>,
    date DATE
) 
WITH ( 
    -- Specify the format of the table as 'PARQUET'
    FORMAT = 'PARQUET',
    -- Specify the partitioning column as 'date'
    PARTITIONING = ARRAY['date']
)