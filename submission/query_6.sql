--Host Activity Datelist Implementation (query_6.sql)

insert into sanniepatron.hosts_cumulated
with yesterday as(
select * 
from sanniepatron.hosts_cumulated
where date = date('2023-01-03')
),
today as(
select 
host,
cast(date_trunc('day',event_time) as date) as event_time,
count(1)
from bootcamp.web_events
where cast(date_trunc('day',event_time) as date) = date('2023-01-04')
group by 
host,
cast(date_trunc('day',event_time) as date) 
)
select
coalesce(y.host, t.host),
case when y.host_activity_datelist is not null 
then ARRAY[t.event_time] || y.host_activity_datelist
else ARRAY[t.event_time]
end as host_activity_datelist,
DATE('2023-01-04') as date
from yesterday y
full outer join today t
on y.host = y.host