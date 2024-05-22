CREATE
OR REPLACE TABLE hosts_cumulated (
    -- 'host': Host name
    host VARCHAR,
    -- 'host_activity_datelist': List of dates host is active
    host_activity_datelist ARRAY(DATE),
    -- 'date': Date host is active
    date DATE
) WITH (
    FORMAT = 'PARQUET',
    partitioning = ARRAY ['date']
)