-- create cumulating user activity table by device
create
or replace table sarneski44638.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
with
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
    -- tag for feedback