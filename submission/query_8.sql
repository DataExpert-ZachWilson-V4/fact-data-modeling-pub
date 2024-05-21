--HW2 query_8
INSERT into hdamerla.host_activity_reduced
With yesterday AS (
select * from 
hdamerla.host_activity_reduced
where DATE(month_start) = DATE('2023-08-02')
), 
today as (
select
  *
from hdamerla.daily_web_metrics
where DATE(date) = DATE('2023-08-02')
)

SELECT
COALESCE(y.host, t.host) as host,
COALESCE(y.metric_name, t.metric_name) as metric_name,
 COALESCE (y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER ))) || ARRAY[t.metric_value] as metric_array,
CAST('2023-08-01' as DATE) as month_start
from yesterday y
full outer join today t
on y.host = t.host and y.metric_name=t.metric_name
