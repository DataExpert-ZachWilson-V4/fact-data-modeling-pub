--very straightforward
--browser_type would be filled in by joining web_events table with devices table
CREATE TABLE derekleung.web_users_cumulated (
  user_id BIGINT,
  browser_type VARCHAR,
  dates_active ARRAY(DATE),
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
