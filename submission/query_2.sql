-- DDL statement to create a cumulating user activity table by device.
CREATE OR REPLACE TABLE vaishnaviaienampudi83291.user_devices_cumulated (
  user_id BIGINT, -- id of the user
  browser_type varchar, --browser from which user logged in
  dates_active ARRAY(DATE), -- CREATING A MAP COLUMN that has browser_type as key and date_list as values
  date DATE
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)
