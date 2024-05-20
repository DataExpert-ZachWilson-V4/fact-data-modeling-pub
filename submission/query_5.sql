CREATE TABLE phabrahao.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    DATE DATE
)
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])

    