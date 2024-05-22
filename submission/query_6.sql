-- query to incrementally populate the cumulative hosts activity datelist table
-- min date in web_events table is '2021-01-02'
insert into
    sarneski44638.hosts_cumulated
with
    prev as (
        select
            *
        from
            sarneski44638.hosts_cumulated
        where
            date = date('2021-01-01') -- @start_date
    ),
    curr as (
        select
            host,
            date(event_time) as date
        from
            bootcamp.web_events
        where
            date(event_time) = date('2021-01-02') --@start_date + 1
        group by -- since want one record per host/day
            1,
            2
    )
select
    coalesce(p.host, c.host) as host,
    case
        when p.host_activity_datelist is null then array[c.date] -- case when not previously in cumulative table then start array of dates with current date
        when c.date is null then p.host_activity_datelist -- case when host not occuring on current date then array of dates is same as previous host_activity_datelist
        else array[c.date] || p.host_activity_datelist -- case when previously in cumulative tabel and host occuring on current date then add current date as first element in previous host_activity_datelist
    end as host_activity_datelist,
    coalesce(p.date + interval '1' day, c.date) as date
from
    prev p
    full outer join curr c on p.host = c.host
    and p.date + interval '1' day = c.date
    -- tag for feedback