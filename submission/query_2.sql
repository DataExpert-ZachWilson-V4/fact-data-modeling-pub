CREATE
OR REPLACE TABLE user_devices_cumulated (
    -- 'user_id': Unique user identifier.
    user_id BIGINT,
    -- 'browser_type': Type of browser used by user
    browser_type VARCHAR,
    -- 'dates_active': Array to store dates representing when a user was active.
    dates_active ARRAY(DATE),
    -- 'date': Date user was active.
    date DATE
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY ['date']
)