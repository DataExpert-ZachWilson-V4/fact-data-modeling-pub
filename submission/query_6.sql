Insert into Jaswanthv.hosts_cumulated
-- Getting prior day snapshot
With yesterday As
(
Select * from Jaswanthv. hosts_cumulated
Where date = CAST('2021-01-01' As date)
),
-- Today's snapshot along with calculating number of visits
today As
(
Select
  host,
  CAST(date_trunc('day',event_time) As Date) As host_activity,
  count(1) As number_of_visits_per_day
  from bootcamp. web_events
  Where CAST(date_trunc('day',event_time) As Date) = CAST('2021-01-02' As Date)
  group by host,
 date_trunc('day',event_time)
  
)

Select 
  COALESCE(y.host,t.host) As host,
  /*Checking if prior day Array exists for host_activity and number_of_visits. If exists appending current day values to respective arrays else creating new arrays with current day values. */
  CASE
    WHEN y.host_activity_datelist Is not null Then ARRAY[host_activity] || y.host_activity_datelist
    ELSE ARRAY[host_activity] 
    END As host_activity_datelist,
  CASE
    WHEN y.number_of_visits Is NOT NULL THEN ARRAY[number_of_visits_per_day]|| y.number_of_visits
    ELSE ARRAY[number_of_visits_per_day]
  END As number_of_visits,
  CAST('2021-01-02' As Date) As date 
from 
yesterday y FULL OUTER JOIN today t
on t.host = y.host

-- Adding extra comment to force the Autograde program run on all files