CREATE OR REPLACE TABLE ebrunt.user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),
  date DATE
)
WITH (
  partitioning = ARRAY[ date ]
)
