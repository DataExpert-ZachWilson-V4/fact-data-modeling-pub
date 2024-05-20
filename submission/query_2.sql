--very straightforward
--just added a unique check for user_id column
CREATE TABLE derekleung.web_users_cumulated (
  user_id BIGINT UNIQUE,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
