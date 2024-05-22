-- query_2
-- Create a new table or replace the existing table 'user_devices_cumulated'
CREATE OR REPLACE TABLE qhamzah.user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(date),
  date DATE
) WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)
