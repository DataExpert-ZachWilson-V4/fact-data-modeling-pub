CREATE OR REPLACE TABLE host_cummulated (
    host varchar,
    host_activity_datelist array(date),
    date date
)
WITH(
    FORMAT = 'parquet', 
    PARTITIONING = ARRAY['date']
)