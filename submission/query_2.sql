CREATE OR REPLACE TABLE dswills94.user_devices_cumulated (
--we're building DDL for cumulation table
user_id BIGINT,
--id of user 
browser_type VARCHAR,
--web browser used 
dates_active ARRAY(DATE),
--Array of dates to track how many times user has been active with a given browser_type
date DATE
--current date
)
WITH (
format = 'PARQUET',
--table formatting
partitioning = ARRAY['date']
--temporal aspect to easily trackly date changes
)
