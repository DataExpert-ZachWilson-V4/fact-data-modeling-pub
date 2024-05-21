CREATE TABLE user_devices_cumulated (
  user_id BIGINT,   -- user_id of the user accessing the site
  browser_type VARCHAR,   -- user's browser type
  dates_active ARRAY(DATE),   -- array to track days active
  date DATE   -- current date
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']   -- partition along the same dates

)
