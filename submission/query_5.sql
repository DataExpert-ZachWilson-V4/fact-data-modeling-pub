CREATE OR REPLACE TABLE nikhilsahni.hosts_cumulated (
    host VARCHAR,                    -- Column to store the host as a VARCHAR
    host_activity_datelist ARRAY(DATE), -- Column to store an array of dates when the host was active
    date DATE                        -- Column to store the date of the record
)
WITH (
    FORMAT = 'PARQUET',              -- Specify the table storage format as Parquet
    PARTITIONING = ARRAY['date']     -- Partition the table by the date column for performance optimization
)
