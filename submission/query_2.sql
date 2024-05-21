CREATE
OR REPLACE TABLE ykshon52797255.user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', PARTITIONING = ARRAY['date'])
