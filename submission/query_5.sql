CREATE OR REPLACE TABLE mmarquez225.hosts_cumulated
(
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
) WITH (
    format='PARQUET',
    partitioning= ARRAY['date']
)