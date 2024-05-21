CREATE OR REPLACE TABLE nancycast01.host_cumulated (

  host VARCHAR,
  host_activity_datelist ARRAY(DATE), -- datelist that tracks how many times a host has been active
  date DATE --ingestion date
)

WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['date']
  )
