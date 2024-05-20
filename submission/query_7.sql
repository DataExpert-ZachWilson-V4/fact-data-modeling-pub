-- CREATE A MONTHLY 'host_activity_reduced' TABLE AS SHOWN IN THE FACT DATA MODELING DAY 3 LAB
CREATE OR REPLACE TABLE host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['metric_name', 'month_start']
)
