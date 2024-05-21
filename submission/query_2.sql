-- Create a table named 'user_devices_cumulated' in the 'ningde95' schema
CREATE TABLE ningde95.user_devices_cumulated (
  user_id BIGINT,          -- Unique identifier for the user
  browser_type VARCHAR,    -- Type of browser used by the user
  dates_active ARRAY(DATE),-- Array of dates when the user was active
  date DATE                -- Date associated with the record
)
-- Specify table storage format and partitioning
WITH (
  FORMAT = 'PARQUET',      -- Use the Parquet format for storage
  partitioning = ['date']  -- Partition the table by the 'date' column
)
