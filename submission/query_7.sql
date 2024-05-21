/*

As shown in the fact data modeling day 3 lab,
write a DDL statement to create a monthly host_activity_reduced table, containing the following fields:

host varchar
metric_name varchar
metric_array array(integer)
month_start varchar

 */

-- Create a new table named 'host_activity_reduced'
CREATE TABLE host_activity_reduced
(
    host VARCHAR,  -- Define a column 'host' with VARCHAR data type to store host names
    metric_name VARCHAR,  -- Define a column 'metric_name' with VARCHAR data type to store the name of the metric
    metric_array ARRAY(INTEGER),  -- Define a column 'metric_array' to store an array of integers representing metric values
    month_start VARCHAR  -- Define a column 'month_start' with VARCHAR data type to store the start of the month as a string
)
WITH
(
    partitioning = ARRAY['metric_name', 'month_start']  -- Specify partitioning on the 'metric_name' and 'month_start' columns to optimize query performance
);


