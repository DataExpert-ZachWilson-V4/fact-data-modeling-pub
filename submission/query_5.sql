--query_5
-- Create a new table or replace the existing table 'hosts_cumulated'
CREATE OR REPLACE TABLE qhamzah.hosts_cumulated (
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  date DATE
) WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)
