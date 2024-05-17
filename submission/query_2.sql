CREATE OR REPLACE TABLE mposada.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active array(DATE),
    date DATE
)
