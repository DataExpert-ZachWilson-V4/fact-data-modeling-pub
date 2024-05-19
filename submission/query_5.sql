CREATE OR REPLACE TABLE ovoxo.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
) WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['date']
)