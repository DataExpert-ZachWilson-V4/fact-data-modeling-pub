INSERT INTO
  pratzo.hosts_cumulated  -- Inserting data into the hosts_cumulated table
WITH

  yesterday AS (
    SELECT
      *
    FROM
      pratzo.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31')  -- previous day
  ),

  today AS (
    SELECT
      host,                                    
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,  -- Truncating event_time to get the event_date
      COUNT(1) AS activity_count              -- Adding count for creating the datelist 
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01')  -- current day
    GROUP BY
      host,
       CAST(date_trunc('day', event_time) AS DATE)  
  )

SELECT
  COALESCE(y.host, t.host) AS host,  -- Handling NULLs
  CASE
  -- If user was active yesterday, extend the array
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]  
  END AS host_activity_datelist,
  DATE('2023-01-01') AS DATE  --Setting date to the get 'current day' across all records to simplify viewing
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host