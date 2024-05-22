CREATE OR REPLACE TABLE ebrunt.hosts_cumulated(
  host VARCHAR,
  host_activity_datelist ARRAY(DATE),
  date DATE
)
WITH (
  partitioning = ARRAY[ 'date' ]
)
