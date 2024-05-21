/*

Write a DDL statement to create a hosts_cumulated table, as shown in the fact data modeling day 2 lab. Except for in the homework, you'll be doing it by host, not user_id.

The schema for this table should include:

host varchar
host_activity_datelist array(date)
date date

 */
-- Create or replace the table 'hosts_cumulated' in the schema 'ameena543246912'
CREATE OR REPLACE TABLE hosts_cumulated
(
    host VARCHAR,  -- Define a column 'host' with VARCHAR data type to store host names
    host_activity_datelist ARRAY(date),  -- Define a column 'host_activity_datelist' to store an array of dates
    date DATE  -- Define a column 'date' with DATE data type to store the date of the record
)
WITH
(
    partitioning = ARRAY['date']  -- Specify partitioning on the 'date' column to optimize query performance
)
