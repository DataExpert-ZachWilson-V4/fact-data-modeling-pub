CREATE OR REPLACE TABLE carloslaguna21592.user_devices_cumulated (
    user_id bigint,
    browser_type varchar,
    dates_active array(date),
    date date
)
WITH (FORMAT = 'PARQUET', PARITIONING = ARRAY['date'])