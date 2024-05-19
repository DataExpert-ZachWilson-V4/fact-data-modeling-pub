CREATE OR REPLACE TABLE nancycast01.user_devices_comulated (

  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE), -- datelist that tracks how many times a user has been active
  date DATE --ingestion date
)

WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['date']
  )


