with
    today as (
        select
            events.host,
            date(events.event_time) date,
            count(1) as hits
        from
            bootcamp.web_events as events
        where
            date(events.event_time) = current_date
        group by
            events.host,
            date(events.event_time)
    ),
    cumulative as (
        select
            *
        from
            fayiztk.hosts_cumulated
        where
            date = date_add('day', -1, current_date)
    )
select
    coalesce(today.host, cumulative.host),
    case
        when cumulative.host is not null
        and today.host is not null then cumulative.host_activity_datelist || array[today.date]
        when cumulative.host is not null
        and today.host is null then cumulative.host_activity_datelist
        else array[today.date]
    end as host_activity_datelist,
    current_date as date
from
    today
    full outer join cumulative on today.host = cumulative.host