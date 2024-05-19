-- Create or replace a table named user_devices_cumulated
CREATE
OR REPLACE TABLE RaviT.user_devices_cumulated (
  user_id bigint,
  browser_type varchar,
  dates_active array(DATE), -- Column to store a list of active dates as an array of DATEs
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', -- Store the table in Parquet format
  partitioning = ARRAY['date']); -- Partition the table by the date column
