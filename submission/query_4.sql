-- convert the date list implementation (dates_active) into the base-2 integer representation 
with
    curr as (
        select
            user_id,
            browser_type,
            dates_active,
            date
        from
            sarneski44638.user_devices_cumulated
        where
            date = date('2021-01-31') -- @end_date of period we'd like to represent in base-2 integer representation; goal is to take dates_active and transform into more compact representation of history; this record has the history as an array of dates called dates_active
    ),
    conversion as (
        select
            user_id,
            browser_type,
            cast(
                case
                    when contains(dates_active, sequence_day) then pow(
                        2,
                        30 - date_diff('day', sequence_day, date) -- 30 will depend on the time period we would like to represent in binary; if it is n days we'd like to represent then fill in n - 1 here; since I'd like to do the month of January which has 31 days I have put 30 here; 
                    )
                    else 0
                end as bigint
            ) as power_of_two_repr
        from
            curr
            cross join unnest (sequence(date('2021-01-01'), date('2021-01-31'))) as t (sequence_day) --@start_date and @end_date of period we would like to represent history
    )
select
    user_id,
    browser_type,
    to_base(sum(power_of_two_repr), 2) as binary_representation_dates_active
from
    conversion
group by
    user_id,
    browser_type