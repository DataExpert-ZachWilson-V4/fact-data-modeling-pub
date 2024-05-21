CREATE TABLE IF NOT EXISTS andreskammerath.host_activity_reduced (
    user_id BIGINT,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)
WITH(
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
)