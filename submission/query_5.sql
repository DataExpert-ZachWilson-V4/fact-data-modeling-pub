-- SQL DDL to create a table for tracking cumulative host activity.
-- This table is designed to cumulate activity data by host over time,
-- storing each host's activity history in an array of dates.

CREATE OR REPLACE TABLE jlcharbneau.hosts_cumulated (
    host VARCHAR,                           -- Stores the host identifier, typically a string.
    host_activity_datelist ARRAY(DATE),     -- An array of DATEs indicating the days on which the host was active.
    date DATE                               -- The date when the record was last updated, to track the latest activity.
) WITH (
   FORMAT = 'PARQUET', -- Specifies the storage format; ORC is often used for efficient storage of columnar data.
   PARTITIONING = ARRAY['date'] -- Partitions the table by the 'date' column for better query performance on temporal data.
)