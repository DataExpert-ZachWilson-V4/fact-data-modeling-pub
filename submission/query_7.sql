-- As shown in the fact data modeling day 3 lab, 
-- write a DDL statement to create a monthly 
-- host_activity_reduced table
CREATE OR REPLACE TABLE jimmybrock65656.host_activity_reduced (
    host VARCHAR,
    metric_name VARCHAR,
    metric_array ARRAY(integer),
    month_start VARCHAR
)
WITH
    (
        format = 'PARQUET',
        partitioning = ARRAY['metric_name', 'month_start']
    )