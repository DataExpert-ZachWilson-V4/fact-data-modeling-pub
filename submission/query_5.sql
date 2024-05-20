-- CREATE THE 'hosts_cumulated' TABLE
-- USING 'host' INSTEAD OF 'user_id' AS SHOWN IN THE FACT DATA MODELING DAY 2 LAB
CREATE OR REPLACE TABLE hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['date']
)