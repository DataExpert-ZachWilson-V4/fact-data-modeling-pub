-- Let's create the table with format Parquet and
-- partitioned by user_id and browser_type
CREATE TABLE IF NOT EXISTS andreskammerath.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['browser_type']
)