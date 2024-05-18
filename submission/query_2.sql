CREATE OR REPLACE TABLE jrsarrat.user_devices_cumulated (
  user_id BIGINT,
  browser_type varchar,
  dates_active ARRAY(DATE),
  date DATE
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
