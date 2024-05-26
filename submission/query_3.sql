
-- user_id	device_id	referrer	host	url	event_time

-- device_id	browser_type	os_type	device_type


insert into hariomnayani88482.user_devices_cumulated
with yesterday as(
  
  select *
  from hariomnayani88482.user_devices_cumulated
  where DATE = DATE('2022-12-31')

),today as(
select 
  user_id,
  browser_type,
  cast(date_trunc('day', event_time)as date) AS event_date
from 
bootcamp.web_events
join bootcamp.devices
using (device_id)
where date_trunc('day', event_time) = date('2023-01-01')
group by user_id,date_trunc('day', event_time),browser_type
)

select 
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS DATE
from  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id and y.browser_type= t.browser_type





