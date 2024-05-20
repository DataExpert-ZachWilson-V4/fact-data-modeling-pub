-- User Devices Activity Int Datelist Implementation (query_4.sql)
with datelist_int as(
select
user_id,
browser_type,
cast(sum(case when contains(dates_active,sequence_date) then
pow(2, 30 - date_diff('day', sequence_date,date))
else 0 
end
)as bigint) as history_int
from sanniepatron.user_devices_cumulated
cross join unnest(sequence(date('2021-01-02'),
date('2023-01-04'))) as t(sequence_date)
group by user_id,browser_type
)
select
user_id,
browser_type,
to_base(history_int,2) as history_in_binary
from datelist_int