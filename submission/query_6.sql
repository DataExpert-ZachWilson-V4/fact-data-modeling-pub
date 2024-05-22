-- Host Activity Datelist Implementation
-- a query to incrementally populate the `hosts_cumulated` table from the `web_events` table.

INSERT INTO siawayforward.hosts_cumulated
WITH yesterday AS (
    SELECT *
    FROM siawayforward.hosts_cumulated
    WHERE date = DATE('2021-01-05')
    
), today AS (
  SELECT
    host,
    DATE(event_time) AS today_date
  FROM bootcamp.web_events
  WHERE DATE(event_time) = DATE('2021-01-06')
  GROUP BY 1, 2
  
)
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL AND t.today_date IS NULL 
    THEN y.host_activity_datelist
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.today_date] || y.host_activity_datelist
    ELSE ARRAY[t.today_date]
  END AS host_activity_datelist,
  COALESCE(t.today_date, y.date + INTERVAL '1' DAY) AS date
FROM yesterday y
FULL OUTER JOIN today t 
  ON y.host = t.host
  -- testing with www.eczachly.com from 01/02 to 01/06 2023
  -- WHERE COALESCE(y.host, t.host) = 'www.eczachly.com'
GROUP BY 1, 2, 3