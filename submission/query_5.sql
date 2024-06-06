-- Create a table to store cumulative host data
CREATE TABLE hosts_cumulated (
    host VARCHAR, -- Host name
    host_activity_datelist ARRAY(DATE), -- List of host activity dates
    DATE DATE -- Date of the record
)
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['date']) -- Specify the format and partitioning