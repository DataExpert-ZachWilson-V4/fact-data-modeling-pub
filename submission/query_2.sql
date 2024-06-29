CREATE OR REPLACE TABLE malmarzooq80856.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['DATE']
)