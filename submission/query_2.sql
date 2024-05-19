CREATE OR REPLACE TABLE user_devices_cummulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['date']
)
