CREATE OR REPLACE TABLE jb19881.hosts_cumulated (
    host varchar COMMENT 'host: ', 
    host_activity_datelist array(date) COMMENT 'datelist implementation that tracks host activity, dates sorted in descending order',
    date date COMMENT 'current date'
)
COMMENT 'This table accumulates host activity . The data is sourced from web_events dataset.'
WITH
    (
        -- The Parquet file format is used to optimize for analytical query loads
        format = 'PARQUET',
        -- Partitioned by 'date' for efficient time-based data processing and analysis.
        partitioning = ARRAY['date']
    )