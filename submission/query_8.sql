--HW2 query_8
INSERT into hdamerla.host_activity_reduced
With yesterday AS (
select * from 
hdamerla.host_activity_reduced
where(month_start) =('2023-08-01')
), 
today as (
select
  *
from hdamerla.daily_web_metrics
where (date) = DATE('2023-08-02')
)

SELECT
COALESCE(y.host, t.host) as host,
COALESCE(y.metric_name, t.metric_name) as metric_name,
 COALESCE(
    y.metric_array,
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
 '2023-08-01' as month_start
from today t
full outer join yesterday y
on y.host = cast(t.host as varchar) and y.metric_name=t.metric_name
