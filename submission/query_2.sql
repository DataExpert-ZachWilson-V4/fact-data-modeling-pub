-- Creating a user devices cumulated table to track user activity using different browsers
CREATE OR REPLACE TABLE pratzo.user_devices_cumulated (
  user_id BIGINT,                
  browser_type VARCHAR,          
  dates_active ARRAY(DATE),      -- Datelist that tracks how many times a user has been active with a given browser type
  date DATE                      
)
WITH (
  FORMAT = 'PARQUET'           
)