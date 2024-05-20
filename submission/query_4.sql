--HW2 query_4
With today AS (
select * from 
  hdamerla.user_devices_cumulated
  where date = DATE('2023-01-07')
),
date_list_int AS (
select 
user_id,
browser_type,
CAST(SUM(CASE WHEN CONTAINS(dates_active, sequence_date) THEN
POW(2, 31 - DATE_DIFF('day', sequence_date, DATE('2023-01-01')))
ELSE 0
END
) AS BIGINT
) as history_int
 from today
CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) as t(sequence_date)
group by user_id, browser_type
)

select *,
TO_BASE(history_int, 2) as history_in_binary,
FROM_BASE('11111110000000000000000000000000', 2) AS weekly_base,
BIT_COUNT(history_int, 64) as num_days_active,
BIT_COUNT(BITWISE_AND(history_int, FROM_BASE('11111110000000000000000000000000', 2)), 64) > 0 as is_weekly_active,
BIT_COUNT(BITWISE_AND(history_int, FROM_BASE('00000001111111000000000000000000', 2)), 64) > 0 as is_weekly_active_last_week,
BIT_COUNT(BITWISE_AND(history_int, FROM_BASE('11100000000000000000000000000000', 2)), 64) > 0 as is_active_last_three_days
from date_list_int
