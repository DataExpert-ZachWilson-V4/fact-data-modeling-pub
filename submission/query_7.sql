CREATE TABLE zachwilson.monthly_array_web_metrics (
    user_id BIGINT,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)
WITH(
    FORMAT = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
)