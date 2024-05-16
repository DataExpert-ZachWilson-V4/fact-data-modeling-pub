CREATE TABLE xeno.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date date
)
WITH
    (
        FORMAT = 'PARQUET',
        partitioning = ARRAY['date']
    )