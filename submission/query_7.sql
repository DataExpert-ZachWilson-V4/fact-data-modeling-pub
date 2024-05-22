CREATE
OR REPLACE TABLE host_activity_reduced (
    -- 'host': Host name.
    host VARCHAR,
    -- 'metric_name': Name of the metric, describing the type of activity being measured
    metric_name VARCHAR,
    -- 'metric_array': Array of integers representing the values of the metric over time.
    metric_array ARRAY(INTEGER),
    -- 'month_start': A string representing the start date of the month to which the metrics belong.
    month_start VARCHAR
) WITH (
    FORMAT = 'PARQUET',
    partitioning = ARRAY ['metric_name', 'month_start']
)