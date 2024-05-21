-- Create table user_devices_cumulated to store cumulative user activity by browser_type

CREATE OR REPLACE TABLE shruthishridhar.user_devices_cumulated (
    user_id BIGINT, -- User id
    browser_type VARCHAR,   -- type of browser used by this user
    dates_active ARRAY(DATE),   -- dates when user was active
    date DATE   -- current date of activity
)
WITH (
    format = 'PARQUET', -- setting data format as PARQUET
    partitioning = ARRAY['date']  -- partitioning this data based on date
)