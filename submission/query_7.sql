-- QUERY N.7


-- Reduced Host Fact Array DDL (query_7.sql)
-- As shown in the fact data modeling day 3 lab, write a DDL statement
--  to create a monthly host_activity_reduced table, containing the following fields

-- host varchar
-- metric_name varchar
-- metric_array array(integer)
-- month_start varchar


-- CREATE TABLE vzucher.monthly_host_activity_recuded (
--     host VARCHAR,
--     metric_name VARCHAR,
--     metric_array ARRAY(INTEGER),
--     month_start VARCHAR
-- )

CREATE TABLE host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
)
WITH (
  partitioning = ARRAY['metric_name', 'month_start']
)