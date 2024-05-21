CREATE TABLE user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),
  date DATE
)
WITH (
  format = 'parquet',
  partitioning = ARRAY['date']
)
