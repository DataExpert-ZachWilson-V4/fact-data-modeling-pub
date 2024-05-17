CREATE OR REPLACE TABLE jsgomez14.user_devices_cumulated
(
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
) WITH (
    format='PARQUET', --specify the format of the table.
    partitioning = ARRAY['date'] --specify the partitioning column. 
    -- To take advantage of Parquet's run length encoding 
    -- and compress repetitive data to save disk space.
)