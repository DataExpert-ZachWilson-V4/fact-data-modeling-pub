-- Create or replace a table named 'user_devices_cumulated'
CREATE OR REPLACE TABLE user_devices_cumulated (
    user_id BIGINT,                    -- Column to store user IDs (assumed to be large integers)
    browser_type VARCHAR,              -- Column to store browser types (assumed to be strings)
    dates_active ARRAY(DATE),          -- Column to store an array of active dates (assumed to be dates)
    date DATE                          -- Column to store a single date (assumed to be a date)
) WITH (
    format = 'PARQUET',                -- Specifies the storage format as Parquet
    partitioning = ARRAY['date']       -- Defines partitioning by the 'date' column
)
