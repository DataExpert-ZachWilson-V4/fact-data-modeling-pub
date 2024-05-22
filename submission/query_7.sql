CREATE OR REPLACE TABLE raniasalzahrani.host_activity_reduced (
    host VARCHAR,                   -- The host identifier
    metric_name VARCHAR,            -- The name of the metric
    metric_array ARRAY(INTEGER),    -- Array of metric values
    month_start VARCHAR             -- The start of the month in YYYY-MM format
)
WITH (
    format = 'PARQUET',             -- Store the table in Parquet format for efficient storage and querying
    partitioning = ARRAY['month_start']  -- Partition the table by the 'month_start' column
)
