--Host Activity Datelist DDL 

CREATE
OR REPLACE TABLE hariomnayani88482.hosts_cumulated (
  host varchar,
  host_activity_datelist array(DATE),
  DATE DATE
)
WITH
  (
    FORMAT = 'parquet', 
    partitioning = ARRAY['date']
  )