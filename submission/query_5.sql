CREATE OR REPLACE TABLE rgindallas.hosts_cumulated ( 
  host varchar, host_activity_datelist array(date), date date ) 
  WITH ( format = 'PARQUET', format_version = 2, partitioning = ARRAY['date'] )
