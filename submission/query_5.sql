 -- Create the saismail.hosts_cumulated table
CREATE
OR REPLACE TABLE saismail.hosts_cumulated(
  host VARCHAR, -- Type of browser used by the user
  host_activity_datelist ARRAY(DATE), -- Array of dates the host was active
  "date" DATE -- Specific date for the record
)
WITH
  (
    FORMAT = 'PARQUET', -- Storage format for the table
    partitioning = ARRAY['host'] -- Partition the table by host
  )