--HW2 query_3
/*incremental query to populate the table user_devices_cumulated from the web_events and devices tables*/

INSERT INTO hdamerla.user_devices_cumulated
WITH yesterday AS (
  SELECT * FROM   hdamerla.user_devices_cumulated 
  WHERE date = DATE('2022-12-31')
),
today AS (
  SELECT 
    w.user_id, 
    d.browser_type,
    CAST(date_trunc('day', w.event_time) as DATE) as event_date, 
    COUNT(1) 
  FROM bootcamp.web_events w
  LEFT JOIN bootcamp.devices d --join to devices table to obtain the browswer type
  ON w.device_id = d.device_id
  WHERE date_trunc('day', w.event_time) = DATE('2023-01-01')
  GROUP BY w.user_id, d.browser_type, CAST(date_trunc('day', w.event_time) AS DATE)
)
  
SELECT
COALESCE(y.user_id, t.user_id) as user_id,
COALESCE(y.browser_type, t.browser_type) as browser_type,
CASE when y.dates_active is NOT NULL THEN ARRAY[t.event_date] || y.dates_active
ELSE ARRAY[t.event_date]
END as dates_active,
CAST('2023-01-01' as DATE) as date
from yesterday y
full outer join today t
on y.user_id = t.user_id and y.browser_type = t.browser_type  
