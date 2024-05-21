CREATE OR REPLACE TABLE ykshon52797255.user_devices_cumulated (
  user_int BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(date),
  date date
)
WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['date']
  )
