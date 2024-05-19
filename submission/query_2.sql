-- Create or replace the table user_devices_cumulated
CREATE OR REPLACE TABLE nonasj.user_devices_cumulated (
    -- The user ID
    user_id BIGINT,

    -- The type of browser used by the user
    browser_type VARCHAR,

    -- Array of dates when the user was active
    dates_active ARRAY(DATE),

    -- The date of the activity (used for partitioning)
    date DATE
)
WITH (
    -- Specify the file format for the table
    FORMAT = 'PARQUET',

    -- Partition the table by the date column for performance optimization
    partitioning = ARRAY['date']
)