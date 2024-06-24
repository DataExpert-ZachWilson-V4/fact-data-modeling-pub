CREATE OR REPLACE TABLE jb19881.host_activity_reduced (
    host varchar COMMENT 'host: ', 
    metric_name varchar COMMENT 'name of metric', 
    metric_array array(integer) COMMENT 'datelist implementation that tracks host activity, dates sorted in descending order',
    month_start varchar COMMENT 'current date'
)
COMMENT 'This table accumulates host activity . The data is sourced from web_events dataset.'
WITH
    (
        -- The Parquet file format is used to optimize for analytical query loads
        format = 'PARQUET',
        -- Partitioned by 'date' for efficient time-based data processing and analysis.
        partitioning = ARRAY['metric_name', 'month_start']
    )