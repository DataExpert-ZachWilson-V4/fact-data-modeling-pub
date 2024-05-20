-- Create a table named 'host_activity_reduced' in the schema 'martinaandrulli'
CREATE OR REPLACE TABLE martinaandrulli.host_activity_reduced (
    host VARCHAR, -- The name of the host
    metric_name VARCHAR, -- The name of the metric
    metric_array ARRAY(INTEGER), -- An array of metric values
    month_start VARCHAR -- The starting month of the data
) 
WITH (
    format='PARQUET',
    partitioning= ARRAY['month_start', 'metric_name'] -- Partition based on month_start and metric_name to ensure faster I/O if queries are based on the starting month AND on the name of the metric
)