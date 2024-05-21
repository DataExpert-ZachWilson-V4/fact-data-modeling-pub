CREATE OR REPLACE TABLE jsgomez14.hosts_cumulated
(
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
) WITH (
    format='PARQUET', --specify the format of the table.
    partitioning= ARRAY['date']
    -- Specify the partitioning column.
    -- To take advantage of Parquet's run length encoding 
    -- and compress repetitive data to save disk space.
)
