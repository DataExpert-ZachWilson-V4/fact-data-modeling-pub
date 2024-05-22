CREATE OR REPLACE TABLE raniasalzahrani.hosts_cumulated (
    host VARCHAR,                   -- The host identifier
    host_activity_datelist ARRAY(DATE), -- Array of dates when the host was active
    date DATE                      -- The date the record is created
)
WITH (
    format = 'PARQUET',            -- Store the table in Parquet format for efficient storage and querying
    partitioning = ARRAY['date']   -- Partition the table by the 'date' column
)
