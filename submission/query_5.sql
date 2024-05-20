-- Create a table named hosts_cumulated
CREATE TABLE hosts_cumulated (
    -- Column for host, accepting VARCHAR data type
    host VARCHAR,
    -- Column for host_activity_datelist, accepting ARRAY of DATE data type
    host_activity_datelist ARRAY(DATE),
    -- Column for DATE, accepting DATE data type (Note: consider renaming to avoid conflicts with reserved keywords)
    DATE DATE
)
-- With options for table formatting and partitioning
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])