CREATE OR REPLACE TABLE nikhilsahni.user_devices_cumulated (
    user_id BIGINT,             -- Column to store user IDs as BIGINT
    browser_type VARCHAR,       -- Column to store the type of browser as a VARCHAR
    dates_active ARRAY(DATE),   -- Column to store an array of dates when the user was active
    date DATE                   -- Column to store the date of the record
)
WITH (
    FORMAT = 'PARQUET',         -- Specify the table storage format as Parquet
    PARTITIONING = ARRAY['date']-- Partition the table by the date column for performance optimization
)
