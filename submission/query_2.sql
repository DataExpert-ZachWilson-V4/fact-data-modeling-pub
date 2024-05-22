CREATE OR REPLACE TABLE user_devices_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),		--Array of dates active in descending order
  date DATE		--Current date, used for partitioning
) WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['date']
)

