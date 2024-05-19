CREATE OR REPLACE TABLE ovoxo.host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
) WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['metric_name', 'month_start']
)