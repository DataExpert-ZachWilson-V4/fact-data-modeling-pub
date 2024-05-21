 INSERT INTO adbeyer.hosts_cumulated with yesterday as (
  SELECT 
    * 
  FROM 
    adbeyer.hosts_cumulated 
  WHERE 
    date = DATE('2023-01-02')
), 
today as (
  SELECT 
    host, 
    DATE(event_time) as date, 
    COUNT(1) 
  FROM 
    bootcamp.web_events 
  WHERE 
    DATE(event_time) = DATE('2023-01-03') 
  GROUP BY 
    host, 
    DATE(event_time)
) 
SELECT 
  COALESCE(today.host, yesterday.host), 
  CASE WHEN yesterday.host_activity_datelist is null THEN ARRAY[today.date] ELSE ARRAY[today.date] || yesterday.host_activity_datelist END as host_activity_datelist, 
  COALESCE(
    today.date, 
    date_add('day', 1, yesterday.date)
  ) as date 
FROM 
  today FULL 
  OUTER JOIN yesterday ON today.host = yesterday.host
