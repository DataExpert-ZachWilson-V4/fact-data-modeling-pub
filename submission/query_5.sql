CREATE TABLE meetapandit89096646.hosts_cumulated (
-- DDL for cumulated table grouped by host
  host VARCHAR,
  -- array date list of days active
  host_activity_datelist ARRAY(DATE),
  -- current snapshot date
  DATE DATE
)
WITH
-- dtore file as parquet in Apache Iceberg
-- store records with same date in same partition for ease of retrieval
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])
 