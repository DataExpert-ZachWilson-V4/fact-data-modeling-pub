CREATE TABLE IF NOT EXISTS user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),  --Array that holds all active dates
  date DATE
)
WITH (
  format = 'parquet',
  partitioning = ARRAY['date']
)
