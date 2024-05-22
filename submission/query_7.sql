-- metric_array contains metric values in ascending order of date e.g. 2023-01-01, 2023-01-02, 2023-01-03, ....

CREATE OR REPLACE TABLE tharwaninitin.host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),    -- array of values in ascending order by date
    month_start VARCHAR             -- current month
) WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['metric_name','month_start']
)