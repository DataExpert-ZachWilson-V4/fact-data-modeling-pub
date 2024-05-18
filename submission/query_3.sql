-- query to incrementally populate the cumulative user devices activity datelist table
-- min date in web_events table is '2021-01-02'
insert into
    sarneski44638.user_devices_cumulated
with
    prev_day as (
        select
            *
        from
            sarneski44638.user_devices_cumulated
        where
            date = date('2021-01-01') -- @start_date
    ),
    curr_day as (
        select
            user_id,
            browser_type,
            cast(event_time as date) as event_date
        from
            bootcamp.web_events w
            join bootcamp.devices d on w.device_id = d.device_id
        where
            cast(event_time as date) = date('2021-01-02') --@start_date + 1
        group by
            1,
            2,
            3
    )
select
    coalesce(c.user_id, p.user_id) as user_id,
    coalesce(c.browser_type, p.browser_type) as browser_type,
    case
        when p.dates_active is not null
        and c.event_date is not null then array[c.event_date] || p.dates_active
        when p.dates_active is not null
        and c.event_date is null then p.dates_active
        when p.dates_active is null then array[c.event_date]
    end as dates_active,
    coalesce(c.event_date, p.date + interval '1' day) as date
from
    prev_day p
    full outer join curr_day c on p.user_id = c.user_id
    and p.browser_type = c.browser_type
