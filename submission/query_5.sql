-- QUERY N.5

-- Host Activity Datelist DDL (query_5.sql)
-- Write a DDL statement to create a hosts_cumulated table,
-- as shown in the fact data modeling day 2 lab. Except for 
-- in the homework, you'll be doing it by host, not user_id

-- The schema for this table should include:
-- host varchar
-- host_activity_datelist array(date)
-- date date

CREATE OR REPLACE TABLE vzucher.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])

    