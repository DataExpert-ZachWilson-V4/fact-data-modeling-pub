-- Create a table named host_activity_reduced
CREATE OR REPLACE TABLE nancyatienno21998.host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)

-- With options for table formatting and partitioning
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['metric_name','month_start'])