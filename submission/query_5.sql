-- The `hosts_cumulated` table is designed to store cumulative activity data for each host.
-- Schema includes:
-- I. `host` (VARCHAR): Stores the name or address of the host.
-- II. `host_activity_datelist` (ARRAY(DATE)): Stores an array of dates indicating when the host was active.
-- III. `date` (DATE): Stores the current or latest date of the activity data.

CREATE TABLE iliamokhtarian.hosts_cumulated (
    host VARCHAR,                           -- Column to store the host name or address
    host_activity_datelist ARRAY(DATE),     -- Column to store an array of dates when the host was active
    date DATE                               -- Column to store the current or latest date for the activity data
) 
WITH (
    FORMAT = 'PARQUET',                     -- Specifies that the table data will be stored in Parquet format
    partitioning = ARRAY ['date']           -- Specifies that the table will be partitioned by the 'date' column
)
-- The table uses the Parquet format for efficient data storage and retrieval. Parquet is optimized for big data processing frameworks with its columnar storage format.
-- The table is partitioned by the `date` column, enhancing query performance by allowing the database to scan only relevant partitions based on the date, thus reducing the data read during queries.
