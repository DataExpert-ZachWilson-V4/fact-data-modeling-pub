--User Devices Activity Datelist DDL 
create or replace table
hariomnayani88482.user_devices_cumulated
(
  user_id bigint,
  browser_type varchar,
  dates_active array(date),
  date date
)
with(
format='PARQUET',
partitioning =ARRAY['date']
)