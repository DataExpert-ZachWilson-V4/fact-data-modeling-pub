/* A DDL statement to create a cumulating user activity table by device */

CREATE TABLE user_devices_cumulated (
  -- user_id of the user accessing the site
  user_id BIGINT,
  -- user's browser type
  browser_type VARCHAR,
  -- array to track days active
  dates_active ARRAY(DATE),
  -- current date
  date DATE
)
WITH (
  format = 'PARQUET',
  -- partition along the same dates 
  partitioning = ARRAY['date']
)