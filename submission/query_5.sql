-- a DDL statement to create a `hosts_cumulated` table, as shown in the fact data modeling day 2 lab. 
-- Except for in the homework, you'll be doing it by `host`, not `user_id`.

CREATE OR REPLACE TABLE siawayforward.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE 
)
WITH (
    format = 'PARQUET',
    -- we choose date because its the only time dim
    partitioning = ARRAY['date']
)