CREATE OR REPLACE TABLE dennisgera.user_devices_cumulated (
    -- user_id: the user id
    user_id bigint,
    -- browser_type: the browser type
    browser_type VARCHAR,
    -- dates_active: the dates the user was active
    dates_active ARRAY(DATE),
    -- date: the date
    date DATE
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY ['date']
)
