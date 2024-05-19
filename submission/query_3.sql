Insert into Jaswanthv.user_devices_cumulated
-- Getting prior day snapshot
With yesterday As
(
Select * from Jaswanthv.user_devices_cumulated
where date = CAST('2020-12-31' As date)
),
-- This is for current day
today As
(
Select
  w.user_id As user_id,
  d.browser_type As browser_type,
  CAST(date_trunc('day',w.event_time) As date) As dates_active
from bootcamp.devices d Join bootcamp.web_events w on 
d.device_id = w.device_id where date_trunc('day',event_time) = CAST('2021-01-01' As Date) /*Converting timestamp to date and applying in the filter to get current day data*/
group by w.user_id, d.browser_type,date_trunc('day',w.event_time) 
)
Select 
  COALESCE(y.user_id,t.user_id) As user_id,
  COALESCE(y.browser_type,t.browser_type) As browser_type,  
  CASE 
    When y.dates_active Is not null then ARRAY[t.dates_active] || y.dates_active /*Checking if prior day Array exists and if exists appending current days active_date else create a Array as below */
    ELSE ARRAY[t.dates_active]
  END AS dates_active,
  CAST('2021-01-01' As Date) As date
from yesterday y FULL OUTER JOIN today t on y.user_id = t.user_id