-- Creates a cumulated daily fact table grouped by host.
-- This table is designed to track host activity, partitioned by date for optimal query performance
CREATE OR REPLACE TABLE shashankkongara.hosts_cumulated (
    host VARCHAR,                        -- Column to store host name
    host_activity_datelist ARRAY(DATE),  -- Array of DATEs to store a list of active dates for each host - tracks host daily activity
    date DATE                            -- DATE column used to partition the table
)
WITH (
    FORMAT = 'PARQUET',                  -- Storing data in Parquet Format for efficiency
    partitioning = ARRAY['date']         -- Partitioning the table by 'date' for optimized queries and quick data retrieval
);
