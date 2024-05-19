insert into fayiztk.user_devices_cumulated
with
    today as (
        select
            events.user_id,
            events.device_id,
            date(events.event_time) date,
            count(1)
        from
            bootcamp.web_events as events
        where
            date(events.event_time) = current_date
        group by
            events.user_id,
            events.device_id,
            date(events.event_time)
    ),
    today_joined as (
        select
            today.user_id as user_id,
            devices.browser_type as browser_type,
            today.date as date
        from
            today
            left join bootcamp.devices on today.device_id = devices.device_id
    ),
    cumulative as (
        select
            *
        from
            fayiztk.user_devices_cumulated
        where
            date = date_add('day', -1, current_date)
    )
select
    coalesce(today_joined.user_id, cumulative.user_id),
    coalesce(
        today_joined.browser_type,
        cumulative.browser_type
    ),
    case
        when cumulative.user_id is not null then cumulative.dates_active || ARRAY[today_joined.date]
        else ARRAY[today_joined.date]
    end as dates_active,
    current_date as date
from
    today_joined
    full outer join cumulative on today_joined.user_id = cumulative.user_id