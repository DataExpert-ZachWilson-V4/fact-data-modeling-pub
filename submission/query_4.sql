-- 878456185
with
    cumulated_with_data_date as (
        select
            user_id,
            browser_type,
            dates_active,
            date,
            data_date
        from
            fayiztk.user_devices_cumulated
            cross join unnest (sequence(date('2021-01-26'), date('2021-01-28'))) as seq (data_date)
    ),
    culmulated_with_datelist_as_binary as (
        select
            user_id,
            browser_type,
            date,
            to_base(
                cast(
                    sum(
                        case
                            when contains(dates_active, data_date) then pow(2, 30 - date_diff('day', data_date, date))
                            else 0
                        end
                    ) as bigint
                ),
                2
            ) as date_list_binary
        from
            cumulated_with_data_date
        group by
            user_id,
            browser_type,
            date
    )
select
    *
from
    culmulated_with_datelist_as_binary