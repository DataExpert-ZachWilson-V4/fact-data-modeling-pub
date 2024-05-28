-- DDL statement to create or replace the 'hosts_cumulated' table in the 'videet' schema.
CREATE OR REPLACE TABLE videet.hosts_cumulated (
    -- 'host' column of type VARCHAR to store the identifier or name of the host.
    host                     VARCHAR,

    -- 'host_activity_datelist' column of type ARRAY(DATE) to store an array of dates
    -- representing the days on which the host was active.
    host_activity_datelist   ARRAY(DATE),

    -- 'date' column of type DATE to store the last update or the data aggregation date.
    date                     DATE
)
WITH (
    -- File format for table storage set to 'PARQUET' for efficient data compression and encoding.
    FORMAT = 'PARQUET',

    -- Defining partitioning strategy for the table. The table is partitioned by the 'date' column.
    PARTITIONING = ARRAY['date']
)