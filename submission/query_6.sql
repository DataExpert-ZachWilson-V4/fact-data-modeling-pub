insert into sanchit.hosts_cumulated
with yesterday as (
    select *
    from sanchit.hosts_cumulated
    where date = date('2023-01-02')
),

today as (
    select
        host,
        cast(date_trunc('day', event_time) as date) as event_date
    from
        bootcamp.web_events
    where date_trunc('day', event_time) = date('2023-01-03')
    group by host, date_trunc('day', event_time)
)

select
    coalesce(y.host, t.host) as host,
    case
        when
            y.host_activity_datelist is not null
            then array[t.event_date] || y.host_activity_datelist
        else array[t.event_date]
    end as host_activity_datelist,
    date('2023-01-03') as date
from yesterday as y
full outer join today as t on y.host = t.host
