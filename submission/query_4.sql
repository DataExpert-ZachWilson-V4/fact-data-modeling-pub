with data as (
    select *
    from sanchit.user_devices_cumulated
    where date = date('2023-01-05')
)

select
    user_id,
    browser_type,
    date('2023-01-5') as date,
    to_base(cast(sum(case
        when
            contains(dates_active, sequence_date)
            then pow(2, 31 - date_diff('day', sequence_date, date))
        else 0
    end) as bigint), 2) as dates_active
from data cross join
    unnest(sequence(date('2023-01-01'), date('2023-01-07')))
group by
    user_id,
    browser_type
