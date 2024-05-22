
--HW2 query_2
/*DDL for user_devices_cumulated */

CREATE or REPLACE TABLE user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE), --defining date array
  date DATE
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)
