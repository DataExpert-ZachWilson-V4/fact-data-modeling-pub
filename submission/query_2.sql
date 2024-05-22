/*-----------------------------------------------------------
create a table user_devices_cumulated that tracks users and
browser type 
*/-----------------------------------------------------------
CREATE
OR REPLACE TABLE ykshon52797255.user_devices_cumulated (
  --user_id: user that accessed the web
  user_id BIGINT,
  -- browser_type: device type that accessed the web by the user
  browser_type VARCHAR,
  -- dates_active: dates that the web was access by the user_id and browser_type
  dates_active ARRAY(DATE),
  -- date: current date
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', PARTITIONING = ARRAY['date'])
