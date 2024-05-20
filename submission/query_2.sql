-- Creates a table that cumulates user activity by device.
CREATE TABLE
    user_devices_cumulated (
        user_id BIGINT,            -- Column to store the user's unique identifier
        browser_type VARCHAR,      -- Column to store the type of browser used by the user
        dates_active ARRAY (DATE), -- Column to store an array of dates where the user was active
        record_date DATE                  -- Column to store the date of the record
    )
    WITH
  (
    FORMAT = 'PARQUET',           -- Stores data in PARQUET format
    partitioning = ARRAY['record_date']  -- Partitions the table by the "date" column
  )
