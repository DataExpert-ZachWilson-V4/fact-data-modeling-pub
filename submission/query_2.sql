CREATE OR REPLACE TABLE jb19881.user_devices_cumulated (
    user_id bigint NOT NULL COMMENT 'Unique identifier for each user.',
    browser_type varchar COMMENT 'browser type: Chrome, Chrome Mobile, Firefox, etc.', 
    dates_active array(date) COMMENT 'datelist implementation that tracks how many times a user has been active with a given browser_type, dates sorted in descending order',
    date date COMMENT 'current date'
)
COMMENT 'This table accumulates web activity by user. The data is sourced from the devices and web_events datasets.'
WITH
    (
        -- The Parquet file format is used to optimize for analytical query loads
        format = 'PARQUET',
        -- Partitioned by 'date' for efficient time-based data processing and analysis.
        partitioning = ARRAY['date']
    )