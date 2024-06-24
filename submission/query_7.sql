CREATE OR REPLACE TABLE jb19881.host_activity_reduced (
    host varchar COMMENT 'host', 
    metric_name varchar COMMENT 'name of metric', 
    metric_array array(integer) COMMENT 'array of metric values for the month',
    month_start varchar COMMENT 'first date of month'
)
COMMENT 'This table reduces metric data sourced from daily_web_metrics dataset.'
WITH
    (
        -- The Parquet file format is used to optimize for analytical query loads
        format = 'PARQUET',
        -- Partitioned efficient time-based data processing and analysis.
        partitioning = ARRAY['metric_name', 'month_start']
    )