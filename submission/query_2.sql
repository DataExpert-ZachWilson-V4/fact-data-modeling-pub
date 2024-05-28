-- DDL statement to create a cumulating user activity table by device
CREATE OR REPLACE TABLE positivelyamber.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR, 
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
    -- Parquet formatting
    format = 'PARQUET',
    -- Partition by date
    partitioning = ARRAY['date']
)