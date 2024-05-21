-- Define a CTE named 'yesterday'
WITH yesterday AS (
  -- Select all records from 'hosts_cumulated' where the date is '2023-01-06'
  SELECT *
  FROM ningde95.hosts_cumulated
  WHERE date = DATE('2023-01-06')
),

-- Define a CTE named 'today'
today AS (
  -- Select the host and the event_date truncated to the day from 'web_events' where the event_time is '2023-01-07'
  SELECT 
    host,
    CAST(date_trunc('day', event_time) AS DATE) AS event_date
  FROM bootcamp.web_events
  WHERE date_trunc('day', event_time) = DATE('2023-01-07')
  GROUP BY host, date_trunc('day', event_time)
)

-- Final SELECT statement to combine 'yesterday' and 'today' data
SELECT 
  COALESCE(y.host, t.host) AS host,  -- Combine 'host' from 'yesterday' and 'today', preferring non-null values
  COALESCE(y.host_activity_datelist, ARRAY[]) || ARRAY[t.event_date] AS host_activity_datelist,  -- Combine 'host_activity_datelist' from 'yesterday' with 'event_date' from 'today'
  DATE('2023-01-07') AS date  -- Set the date for the combined data to '2023-01-07'
FROM 
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host  -- Perform a full outer join on 'yesterday' and 'today' using 'host'
