-- query 5 DDL to create hosts_cumulated table
-- hosts_cumulated table is created to track host activity by date.

CREATE OR REPLACE TABLE aayushi.hosts_cumulated (
    host VARCHAR                                 -- Host name
  , host_activity_datelist ARRAY(DATE)           -- Array of dates representing host activity
  , DATE DATE                                    -- Date for partitioning
)
WITH (
    FORMAT = 'PARQUET'                          -- Storage format is Parquet by default
  , partitioning = ARRAY['date']                -- Partitioned by the 'date' column for efficient time-based analysis
)