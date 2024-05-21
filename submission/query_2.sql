CREATE OR REPLACE TABLE alia.user_devices_cumulated (
    user_id BIGINT NOT NULL,
    browser_type VARCHAR NOT NULL,
    dates_active ARRAY (DATE),
    DATE DATE
)
WITH
(   FORMAT = 'PARQUET',
    partitioning = ARRAY['browser_type','date']
)