-- Create a cumulative table for tracking user_id activity 
-- partitioned by date
CREATE OR REPLACE TABLE user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH
    (
        format = 'PARQUET',
        partitioning = ARRAY['date']
    )