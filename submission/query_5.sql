-- Create or replace a table named hosts_cumulated
CREATE
OR REPLACE TABLE RaviT.hosts_cumulated (
  host varchar, -- Column to store the host as a varchar
  host_activity_datelist array(DATE), -- Column to store a list of activity dates as an array of DATEs
  DATE DATE -- Column to store the date of the record
)
WITH
  (FORMAT = 'PARQUET', -- Store the table in Parquet format
  partitioning = ARRAY['date']) -- Partition the table by the date column