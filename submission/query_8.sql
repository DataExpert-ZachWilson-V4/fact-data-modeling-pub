insert into
    fayiztk.host_activity_reduced
with
    yesterday as (
        select
            *
        from
            fayiztk.host_activity_reduced
        where
            month_start = '2023-08-01'
    ),
    today as (
        select
            *
        from
            fayiztk.daily_web_metrics
        where
            date = date('2023-08-01')
    )
select
    coalesce(t.host, y.host) as host,
    coalesce(t.metric_name, y.metric_name) as metric_name,
    coalesce(
        y.metric_array,
        repeat(
            null,
            cast(
                date_diff('day', date('2023-08-01'), t.date) as integer
            )
        )
    ) || array[t.metric_value] as metric_array,
    '2023-08-01' as month_start
from
    today t
    full outer join yesterday y on t.host = y.host
    and t.metric_name = y.metric_name