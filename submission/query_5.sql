create
or replace table sarneski44638.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
with
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])