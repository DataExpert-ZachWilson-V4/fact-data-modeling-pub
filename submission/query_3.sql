-- Bring data for last 7 days and see how many times a user was activ in last 7 days for a particular browser type
-- We will do incremental load for 1 day at a time for weekly analysis
-- We do this by using 2 CTEs . Yesterday will use cummulative table and today will use original raw table. Here it is web_events table
-- 


-- Query to incrementally load data into user_devices_cumulated one day at a time for one entire week
INSERT INTO ameena543246912.user_devices_cumulated
with yesterday as
(
    SELECT user_id,
    browser_type,
    dates_active,
    date
    FROM ameena543246912.user_devices_cumulated
    WHERE DATE(date) = DATE('2023-01-06')
),
today as
(
    SELECT user_id , browser_type,
    DATE(event_time) as event_date,count(1)
    FROM bootcamp.web_events w
    inner join bootcamp.devices d on w.device_id = d.device_id
    WHERE DATE(event_time) = DATE('2023-01-07')
    GROUP BY 1,2,3
)
SELECT 
    COALESCE(y.user_id , t.user_id) as user_id,
    COALESCE(y.browser_type,t.browser_type) as browser_type,
    CASE WHEN y.dates_active is NOT NULL 
         THEN ARRAY[t.event_date] || y.dates_active 
    ELSE ARRAY[t.event_date]
    END as dates_active,
    DATE('2023-01-07') as DATE
from yesterday y FULL OUTER JOIN today t on y.user_id = t.user_id
