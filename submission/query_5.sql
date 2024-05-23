CREATE OR REPLACE TABLE Jaswanthv.hosts_cumulated
(
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  number_of_visits ARRAY(INTEGER), -- Adding this column to capture number of visits for each host
  date Date
)
WITH
(
  FORMAT = 'PARQUET',
  Partitioning = ARRAY['date'] 
)
  