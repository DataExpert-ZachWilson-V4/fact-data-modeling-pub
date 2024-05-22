-- query_7
-- Create a new table or replace the existing table 'host_activity_reduced'
CREATE OR REPLACE TABLE qhamzah.host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
) WITH (
  format = 'PARQUET',
  partitioning = ARRAY['metric_name', 'month_start']
)
