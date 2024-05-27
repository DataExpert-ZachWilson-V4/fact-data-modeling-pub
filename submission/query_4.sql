--User Devices Activity Int Datelist Implementation 
--Similar to day 2 lab, we calculate the date difference and convert them into powers of 2 and bring them back to string using to_base. 
--This gives us the user activity per user, per browser type, for each month 

with data as (
    select *
    from hariomnayani88482.user_devices_cumulated
    where date = date('2023-01-07')
)

select
    user_id,
    browser_type,
    date('2023-01-07') as date,
    to_base(cast(sum(case
        when
            contains(dates_active, sequence_date)
            then pow(2, 31 - date_diff('day', sequence_date, date))
        else 0
    end) as bigint), 2) as dates_active
from data cross join
    unnest(sequence(date('2023-01-01'), date('2023-01-07'))) as t(sequence_date)
group by
    user_id,
    browser_type