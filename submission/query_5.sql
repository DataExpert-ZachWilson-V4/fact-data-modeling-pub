CREATE TABLE farahakoum199912722.hosts_cumulated
(
    host                   VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date                   DATE
) WITH (FORMAT = 'PARQUET', partitioning = ARRAY['DATE'])