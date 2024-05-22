CREATE OR REPLACE TABLE grisreyesrios.user_devices_cumulated (
    user_id bigint,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
) WITH (
    partitioning = ARRAY ['date']
)
