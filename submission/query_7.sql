-- Create a table named host_activity_reduced
CREATE TABLE host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR
    metric_arry ARRAY(INTEGER),
    month_start VARCHAR
)
-- With options for table formatting and partitioning
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['metric_name','month_start'])