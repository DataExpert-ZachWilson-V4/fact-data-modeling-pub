CREATE OR REPLACE TABLE faraanakmirzaei15025.hosts_cumulated
(
    host VARCHAR,
    host_activity_datelist ARRAY(date),
    date date
    )
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['date'] )
