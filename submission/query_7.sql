CREATE OR REPLACE TABLE jsgomez14.host_activity_reduced
(
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
) WITH (
    format='PARQUET', --specify the format of the table.
    partitioning = ARRAY['metric_name', 'month_start']
    -- Specify the partitioning columns.
    -- To take advantage of Parquet's run length encoding 
    -- and compress repetitive data to save disk space.
)
