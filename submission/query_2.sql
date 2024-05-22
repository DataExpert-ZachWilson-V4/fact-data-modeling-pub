-- a DDL statement to create a cumulating user activity table by device.
-- This table will be the result of joining the `devices` table onto the `web_events` table, 
--  so that you can get both the `user_id` and the `browser_type`.

CREATE OR REPLACE TABLE siawayforward.user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
  format = 'PARQUET',
  -- we choose date because its the only time dim
  partitioning = ARRAY['date']
)