-- Incrementally load ovoxo.hosts_cumulated using bootcamp.web_events. 
-- Add new hosts to table and extends host_activity_datelist array

INSERT INTO ovoxo.hosts_cumulated
WITH
  -- get previous date aggreagted records from ovoxo.hosts_cumulated
  previous_date_records AS (
    SELECT *
    FROM ovoxo.hosts_cumulated
    WHERE date = DATE('2023-01-05')  
  ),
  
  -- get current date records from bootcamp.web_events for host activity
  current_date_records AS (
    SELECT host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM bootcamp.web_events 
    WHERE date_trunc('day', event_time) = DATE('2023-01-06')
    GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
  )
  
SELECT 
  COALESCE(p.host, c.host) AS host,
  CASE 
    WHEN p.host_activity_datelist IS NOT NULL THEN ARRAY[c.event_date] || p.host_activity_datelist
    ELSE ARRAY[c.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-06') AS date
FROM previous_date_records p
FULL OUTER JOIN current_date_records c ON c.host = p.host