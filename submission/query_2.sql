-- create a cumulating table for user_id activity 
-- table by device_id

CREATE OR REPLACE TABLE user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH
    (
        format = 'PARQUET',
        partitioning = ARRAY['date']
    )