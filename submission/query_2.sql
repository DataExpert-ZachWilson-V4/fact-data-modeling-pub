CREATE OR REPLACE TABLE sagararora492.user_devices_cumulated
(
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
) WITH (
    format='PARQUET', -- This is the format we want for compression
    partitioning = ARRAY['date']  -- column on which partition the table
    -- To take advantage of Parquet's run length encoding 
)