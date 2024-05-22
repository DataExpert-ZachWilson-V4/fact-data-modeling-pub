
/*------------------------------------------------------------
create a cumulative table named hosts_cumulated that
tracks the host activity
*/------------------------------------------------------------

CREATE OR REPLACE TABLE ykshon52797255.hosts_cumulated (
  -- host: the host of the web activity
  host VARCHAR,
  -- host_activity_datelist: dates of the activity by the host
  host_activity_datelist array(date),
  -- date: current date
  date date
)

WITH (
  format = 'PARQUET',
  PARTITIONING = ARRAY['date']
)
