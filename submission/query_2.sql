CREATE TABLE meetapandit89096646.user_devices_cumulated (
-- user_id of the user interacting with the website
  user_id BIGINT,
  -- browser type of the visiting user
  browser_type VARCHAR,
  -- binary array of number of days active
  dates_active ARRAY(DATE),
  -- current snapshot date
  date DATE
)
WITH (
    -- format of storing files in Apaceh Iceberg
  format = 'PARQUET',
  -- keys with same date will be stored in the same partition
  partitioning = ARRAY['date']
)
