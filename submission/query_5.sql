CREATE OR REPLACE TABLE akshayjainytl54781.hosts_cumulated ( -- DDL to create hosts cumulated table
  host VARCHAR, -- Host string
  host_activity_datelist ARRAY(DATE), -- Date list of dates indicating host activity
  date DATE -- Date column to partition on
)
WITH (
    FORMAT = 'PARQUET', 
    partitioning = ARRAY['date']
)