insert into sanchit.user_devices_cumulated
with yesterday as (

    select *
    from sanchit.user_devices_cumulated
    where date = date('2022-12-31')

),

today as (
    select
        user_id,
        browser_type,
        cast(date_trunc('day', event_time) as date) as event_date
    from
        bootcamp.web_events
    inner join bootcamp.devices
        on web_events.device_id = devices.device_id
where date_trunc('day', event_time) = date('2023-01-01')
group by user_id, date_trunc('day', event_time), browser_type
)

select
coalesce(y.user_id, t.user_id) as user_id,
coalesce(y.browser_type, t.browser_type) as browser_type,
case
    when
        y.dates_active is not null
        then array[t.event_date] || y.dates_active
    else array[t.event_date]
end as dates_active,
date('2023-01-01') as date
from yesterday as y
full outer join
today as t
on y.user_id = t.user_id and y.browser_type = t.browser_type
