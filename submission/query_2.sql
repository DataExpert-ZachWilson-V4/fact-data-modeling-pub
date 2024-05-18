-- Create or replace a table named 'user_devices_cumulated' in the 'videet' schema
CREATE OR REPLACE TABLE videet.user_devices_cumulated (
    -- Unique identifier for each user
    user_id BIGINT,
    
    -- Type of browser used by the user
    browser_type VARCHAR,
    
    -- Array of dates when the user was active
    dates_active ARRAY(DATE),
    
    -- Date column used for partitioning
    `date` DATE
)
WITH (
    -- Specify the file format for the table as Parquet
    FORMAT = 'PARQUET',
    
    -- Partition the table based on the 'date' column
    PARTITIONING = ARRAY['date']
)