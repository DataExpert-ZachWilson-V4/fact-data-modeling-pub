-- Create or replace the hosts_cumulated table
create or replace table hosts_cumulated
(
  -- Define the host column
  host varchar,
  
  -- Define the host_activity_datelist column
  host_activity_datelist array(date),
  
  -- Define the date column
  date date
)
-- Specify the table format and partitioning
WITH (
format = 'PARQUET',
partitioning = ARRAY['date']
)
