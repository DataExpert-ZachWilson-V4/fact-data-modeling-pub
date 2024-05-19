-- DDL statement to create or replace the 'host_activity_reduced' table in the 'videet' schema
-- This table is intended for storing reduced host activity metrics on a monthly basis.

CREATE OR REPLACE TABLE videet.host_activity_reduced (
    -- 'host' column to store the identifier or name of the host machine or server.
    host VARCHAR,

    -- 'metric_name' column to specify the name of the metric being recorded.
    metric_name VARCHAR,

    -- 'metric_array' column to store an array of integers representing the metric values.
    metric_array ARRAY(INTEGER),

    -- 'month_start' column to specify the start date of the month for which the metrics are recorded.
    month_start VARCHAR    

)
WITH (
    -- Specifies that the data stored in the table should be in the Parquet format,
    -- which is optimized for performance in analytic queries, offering efficient compression and encoding schemes.
    FORMAT = 'PARQUET',
    
    -- Configures the table to be partitioned by the 'month_start' column,
    PARTITIONING = ARRAY['month_start']
)

-- Note:
-- This table design ensures efficient querying by month, as data is partitioned along month boundaries.
-- It supports the storage of various metrics which can be expanded as necessary by simply adding new metric names
-- and corresponding arrays without altering the overall database schema.