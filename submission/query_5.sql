CREATE OR REPLACE TABLE dennisgera.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY (DATE),
    date DATE
) WITH (
    partitioning = ARRAY ['date']
)
