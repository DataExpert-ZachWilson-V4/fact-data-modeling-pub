-- CUMULATED table of dates active by user_id and browser_type

CREATE OR REPLACE TABLE tharwaninitin.user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),		-- array of dates active
  date DATE		                -- current load date
) WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['date']
)