CREATE OR REPLACE TABLE akshayjainytl54781.host_activity_reduced ( -- CTE to hold monthly host activity
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER), -- Date array for each day of the month
    month_start VARCHAR -- Will always be the 1st day of a month
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
)