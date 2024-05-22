-- query_2 User Devices Activity Datelist DDL
-- This table will store cumulative user activity by device by joining 'devices' table with 'web_events' table

CREATE OR REPLACE TABLE aayushi.user_devices_cumulated (
    user_id BIGINT                 -- Unique identifier for user_id
  , browser_type VARCHAR           -- Type of browser used by the user
  , dates_active ARRAY(DATE)       -- Array of dates when the user was active
  , date DATE                      -- Date of record activity that tracks how many times a user has been active with a given browser type
)
WITH (
    FORMAT = 'PARQUET'             -- Storage format is Parquet by default
  , partitioning = ARRAY['date']   -- Partitioned by the 'date' column for efficient time-based analysis
)