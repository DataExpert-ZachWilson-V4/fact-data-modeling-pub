CREATE OR REPLACE TABLE mposada.hosts_cumulated (
    host  varchar,
    host_activity_datelist array(date),
    date date
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY['date']
)
