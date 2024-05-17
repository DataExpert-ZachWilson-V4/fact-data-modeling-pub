-- This query creates a table named 'host_activity_reduced' with the specified columns and properties.

CREATE OR REPLACE TABLE luiscoelho37431.host_activity_reduced (
    host VARCHAR, -- The name of the host
    metric_name VARCHAR, -- The name of the metric
    metric_array ARRAY<INT64>, -- An array of metric values
    month_start VARCHAR -- The starting month of the data
) WITH (
    format = 'PARQUET', -- The file format for storing the table data
    partitioning = ARRAY['month_start'] -- The column used for partitioning the data
)
CREATE OR REPLACE TABLE luiscoelho37431.host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY<INT64>,
    month_start VARCHAR
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY['month_start']
)