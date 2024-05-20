-- Create ovoxo.host_activity_reduced table that contains information of metrics about a host.
-- For each host, metric and month, we have an array of metriv values

CREATE OR REPLACE TABLE ovoxo.host_activity_reduced (
    host VARCHAR, -- host name
    metric_name VARCHAR, -- metric name to track for host
    metric_array ARRAY(INTEGER), -- metric values across multiple days, an array of metric values
    month_start VARCHAR -- month start were metric values start 
) WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['metric_name', 'month_start']
)