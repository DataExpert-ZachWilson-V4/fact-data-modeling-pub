create or replace table rgindallas.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
with
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
    -- tag for feedback
