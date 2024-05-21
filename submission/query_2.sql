-- Creates a daily fact cumulated table to store events in an array by iser and browser_type
CREATE OR REPLACE TABLE shashankkongara.user_devices_cumulated (
  user_id BIGINT,                     -- Column to store user ID
  browser_type VARCHAR,                -- Column to store browser type
  dates_active ARRAY(DATE),            -- Array of DATEs to store active dates for each user-browser combination
  date DATE                            -- DATE column to partition by
)
WITH (
  FORMAT = 'PARQUET',                  -- Storing data in Parquet Format for efficiency
  partitioning = ARRAY['date']         -- Defines 'date' as the partitioning column to optimize query performance and quick data retrieval
)
