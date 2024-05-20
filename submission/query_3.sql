--User Devices Activity Datelist Implementation (query_3.sql)
insert into  sanniepatron.user_devices_cumulated
with yesterday as
(
select * from sanniepatron.user_devices_cumulated
where date = date('2023-01-03')
),

today as (
select 
we.user_id,
d.browser_type,
cast(date_trunc('day',we.event_time) as date) as event_time,
count(1)
from bootcamp.web_events we
join bootcamp.devices d
on we.device_id = d.device_id
where cast(date_trunc('day',we.event_time) as date) = date('2023-01-04')
group by 
we.user_id,
d.browser_type,
cast(date_trunc('day',we.event_time) as date)
)

select
coalesce(y.user_id,t.user_id) as user_id,
coalesce(y.browser_type,t.browser_type) as browser_type,

case when y.dates_active is not null 
then ARRAY[t.event_time] || y.dates_active
else ARRAY[t.event_time]
end as dates_active,

DATE('2023-01-04') as date

from yesterday y
full outer join today t
on y.user_id = t.user_id