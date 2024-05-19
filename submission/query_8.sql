Insert into Jaswanthv.host_activity_reduced
With yesterday As
(
Select * from Jaswanthv.host_activity_reduced
where month_start = '2023-08-01'
),
today As (
Select
  host,
  metric_name,
  metric_value,
  date
FROM Jaswanthv.daily_web_metrics
Where Date = CAST('2023-08-02' As Date)
)
Select
  COALESCE(y.host,t.host) As host,
  COALESCE(y.metric_name,t.metric_name) As metric_name,
  /* Appending Nulls for each day for metrics that doesn't come on month start until they start to show up */
  COALESCE(y.metric_array,REPEAT(NULL,CAST(DATE_DIFF('day',DATE('2023-08-01'),t.date) AS INTEGER))) || ARRAY[t.metric_value] As metric_array,
  '2023-08-01' As month_start
from yesterday y FULL OUTER JOIN today t on
y.host = t.host and y.metric_name = t.metric_name
