CREATE
OR REPLACE TABLE host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)