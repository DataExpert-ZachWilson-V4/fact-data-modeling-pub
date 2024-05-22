--Query 2: Fact Dat Modeling - User Devices Activity Datelist DDL (query_2.sql)

--This table will be the result of joining the devices table onto the web_events table, so that you can get both the user_id and the browser_type.
--The name of this table should be user_devices_cumulated.
--The schema of this table should look like:
--user_id bigint
--browser_type varchar
--dates_active array(date)
--date date
--The dates_active array should be a datelist implementation that tracks how many times a user has been active with a given browser_type.
--The first index of the date list array should correspond to the most recent date (today's date).



CREATE OR REPLACE TABLE saidaggupati.user_devices_cumulated(
  user_id BIGINT,              
  browser_type VARCHAR,    
  --dates_active array should be a datelist implementation that tracks how many times a user has --been active with a given 
  --browser_type.       
  dates_active ARRAY(DATE),    
  date DATE                      
)
WITH (
  FORMAT = 'PARQUET',     --Storage format  
  partitioning = ARRAY['date']
)