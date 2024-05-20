--create hosts-cumulated table
create or replace table fayiztk.hosts_cumulated (
    host varchar,
    host_activity_datelist array (date),
    date date
)
with
    (format = 'parquet',
     partitioning = array['date'])