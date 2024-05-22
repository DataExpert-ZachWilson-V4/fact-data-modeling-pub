CREATE OR REPLACE TABLE host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)
WITH (
    FORMAT = 'PARQUET', PARTITIONING = ARRAY['metric_name', 'month_start']
)

-- CREATE OR REPLACE TABLE xeno.daily_web_metrics (
--     host VARCHAR,
--     metric_name VARCHAR,
--     metric_value INTEGER,
--     month_start VARCHAR
-- )
-- WITH (
--     FORMAT = 'PARQUET', PARTITIONING = ARRAY['metric_name', 'month_start']
-- )