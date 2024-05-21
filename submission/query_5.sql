-- Creates a table of cumilated hosts
CREATE
OR REPLACE TABLE amaliah21315.hosts_cumulated (
    host VARCHAR, -- host name variable
    host_activity_datelist ARRAY(DATE), -- an array of host activity dates
    date DATE -- Column to store the date of the record
) WITH (
    FORMAT = 'PARQUET',-- Stores data in PARQUET format
    partitioning = ARRAY ['date'] -- Partitions the table by the "date" column
)