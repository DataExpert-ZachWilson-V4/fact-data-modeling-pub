--Host Activity Datelist DDL (query_5.sql)

CREATE TABLE sanniepatron.hosts_cumulated (
    host VARCHAR, -- Column to store the host identifier, as a variable character string
    host_activity_datelist array(date), -- Column to store an array of dates on which the host was active
    date DATE -- Column to store the partition date for organizing data
 
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])