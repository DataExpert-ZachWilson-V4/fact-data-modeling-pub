CREATE OR REPLACE TABLE alia.hosts_cumulated (
    host VARCHAR NOT NULL,
    host_activity_datelist ARRAY (DATE),
    DATE DATE
)
WITH
(   FORMAT = 'PARQUET',
    partitioning = ARRAY['date']
)