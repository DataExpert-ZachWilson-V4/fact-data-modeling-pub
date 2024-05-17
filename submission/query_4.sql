WITH

today as (
    select *
    from dennisgera.user_devices_cumulated
    where date = date('2023-01-07')
),

date_list_int as (
    select 
        user_id,
        browser_type,
        cast(
            sum(
                case when contains(dates_active, sequence_date) 
                    then pow(2, 31 - datediff('day', sequence_date, date))
                else 0
                end
            )
            as bigint
        ) as history_int
    from today
    cross join unnest(sequence(date('2023-01-01'), date('2023-01-07'))) as t(sequence_date)
    group by 1, 2
)

select
    *,
    TO_BASE(history_int, 2) as history_in_binary,
    BIT_COUNT(history_int, 32) AS num_days_active 
from date_list_int