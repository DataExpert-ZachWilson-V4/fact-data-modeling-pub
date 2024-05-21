-- Create a table named 'hosts_cumulated' in the 'ningde95' schema
CREATE TABLE IF NOT EXISTS ningde95.hosts_cumulated (
  host VARCHAR,                 -- The hostname
  host_activity_datelist ARRAY(DATE), -- An array of dates when the host was active
  date DATE                     -- The date associated with the record
)
-- Specify table storage format and partitioning
WITH (
  FORMAT = 'PARQUET',           -- Use the Parquet format for storage
  partitioning = ARRAY['date']  -- Partition the table by the 'date' column
)
