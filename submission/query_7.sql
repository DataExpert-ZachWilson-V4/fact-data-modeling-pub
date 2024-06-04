-- As shown in the fact data modeling day 3 lab, write a DDL statement to create a monthly `host_activity_reduced` table, containing the following fields:

-- - `host varchar`
-- - `metric_name varchar`
-- - `metric_array array(integer)`
-- - `month_start varchar`

CREATE TABLE ChrisTaulbee.host_activity_reduced (
  host varchar,
  metric_name varchar,
  metric_array array(integer),
  month_start varchar
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['month_start']
)