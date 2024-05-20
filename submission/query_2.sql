-- Create the saismail.user_devices_cumulated table
CREATE
OR REPLACE TABLE saismail.user_devices_cumulated (
  user_id BIGINT, -- Unique identifier for the user
  browser_type VARCHAR, -- Type of browser used by the user
  dates_active ARRAY(DATE), -- Array of dates the user was active
  "date" DATE -- Specific date for the record
)
WITH
  (
    FORMAT = 'PARQUET', -- Storage format for the table
    partitioning = ARRAY['browser_type'] -- Partition the table by browser_type
  )