--HW2 query_5
/*DDL statement to create a hosts_cumulated table*/

CREATE OR REPLACE TABLE hosts_cumulated(
  host VARCHAR,
  host_activity_datelist ARRAY(DATE), --Array of dates
  date DATE
)
WITH (
  format = 'PARQUET',
  partitioning = ARRAY['date']
)
