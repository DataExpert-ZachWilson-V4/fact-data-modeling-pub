CREATE OR REPLACE TABLE hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),		
  date DATE		
) WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['date']
)
