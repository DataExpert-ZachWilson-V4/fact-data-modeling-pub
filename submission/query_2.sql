-- Create a table named 'user_devices_cumulated' in the schema 'martinaandrulli'
CREATE OR REPLACE TABLE martinaandrulli.user_devices_cumulated (
    -- User ID: Identifier of the user
    user_id BIGINT, 
    -- Browser Type: Browser that the user was using on their device
    browser_type VARCHAR,
    -- Dates_active: Datelist tracking how many times a user has been active with a given browser_type
    dates_active ARRAY<DATE>,
    -- Date: The date this row represents for the user
    date DATE
)
WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['date']
)