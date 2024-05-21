-- create a hosts_cumulated table
-- as shown in the fact data modeling day 2 lab.
-- use host, not user_id (as in lab 2)

CREATE OR REPLACE TABLE jimmybrock65656.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['date']
)