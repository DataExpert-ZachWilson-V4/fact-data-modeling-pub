-- The `hosts_cumulated` table is designed to store cumulative activity data for each host.
-- This schema includes three columns:
-- 1. `host` (VARCHAR): This column stores the name or address of the host.
-- 2. `host_activity_datelist` (ARRAY(DATE)): This column stores an array of dates indicating when the host was active.
-- 3. `date` (DATE): This column stores the current or latest date for the activity data.
-- The table uses the Parquet format for efficient data storage and retrieval. Parquet is a columnar storage format that is optimized for use with big data processing frameworks.
-- Additionally, the table is partitioned by the `date` column. Partitioning improves query performance by allowing the database to scan only relevant partitions based on the date, thus reducing the amount of data read during queries.

CREATE TABLE IF NOT EXISTS vpsjul8468082.hosts_cumulated (
    host VARCHAR,                           -- Column to store the host name or address
    host_activity_datelist ARRAY(DATE),     -- Column to store an array of dates when the host was active
    date DATE                               -- Column to store the current or latest date for the activity data
) 
WITH (
    FORMAT = 'PARQUET',                     -- Specifies that the table data will be stored in Parquet format
    partitioning = ARRAY ['date']           -- Specifies that the table will be partitioned by the 'date' column
)
