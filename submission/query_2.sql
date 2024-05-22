CREATE TABLE raniasalzahrani.user_devices_cumulated (
    user_id BIGINT,             -- The unique identifier for the user
    browser_type VARCHAR,       -- The type of browser used by the user
    dates_active ARRAY(DATE),   -- Array of dates the user was active on the browser
    date DATE                   -- The current date for which the record is created
)
WITH (
    format = 'PARQUET',         -- Store the table in Parquet format for efficient storage and querying
   partitioning = ARRAY['date']  -- Partition the table by the 'date' column
)
