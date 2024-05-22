-- a DDL statement to create a monthly `host_activity_reduced` table, containing the following fields:

CREATE OR REPLACE TABLE siawayforward.host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)
WITH (
    format = 'PARQUET',
    -- month start as our partition field since its the only time dimension
    partitioning = ARRAY['metric_name', 'month_start']
)