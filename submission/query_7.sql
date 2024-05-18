CREATE OR REPLACE TABLE barrocaeric.host_activity_reduced (
    host  varchar,
    metric_name varchar,
    metric_array array(integer),
    month_start varchar
) WITH (
    format = 'PARQUET',
    partitioning =  ARRAY['metric_name', 'month_start']
)