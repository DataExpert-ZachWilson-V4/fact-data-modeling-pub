insert into
    rgindallas.host_activity_reduced
with
    prev as (
        select
            host,
            metric_name,
            metric_array,
            month_start
        from
            rgindallas.host_activity_reduced
        where
            month_start = '2021-01-01' -- @month_start
    ),
    curr as (
        select
            host,
            metric_name,
            metric_value,
            date
        from
            rgindallas.daily_web_metrics
        where
            date = date('2021-01-02') -- iterate through days in month in order
    )
select
    coalesce(p.host, c.host) as host,
    coalesce(p.metric_name, c.metric_name) as metric_name,
    coalesce(
        p.metric_array, -- if host already in host_cumulated then take previous metric_array and concat to add c.metric_value as last value in the array
        repeat( -- if host not already in host_cumulated then add null for every day since the beginning of the month that have already been accounted for (number of days current date is from month_start date) and then add c.metric_value as last value in the array
            null,
            cast(
                date_diff('day', date('2021-01-01'), c.date) as INTEGER -- date(@month_start) same @month_start as lines 13 & 38
            )
        )
    ) || ARRAY[c.metric_value] as metric_array,
    '2021-01-01' as month_start -- @month_start
from
    prev p
    full outer join curr c on p.host = c.host
    and p.metric_name = c.metric_name
    -- tag for feedback
