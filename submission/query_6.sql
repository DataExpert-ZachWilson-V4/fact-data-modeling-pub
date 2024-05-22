-- Insert the results of the query into the hosts_cumulated table
INSERT INTO
  RaviT.hosts_cumulated
WITH
  -- Common table expression (CTE) to get data from the previous day
  yesterday AS (
    SELECT
      * 
    FROM
      RaviT.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31') -- Filter for the specific date
  ),
  -- CTE to get today's web event data
  today AS (
    SELECT
      host, 
      CAST(date_trunc('day', event_time) AS DATE) AS event_date, 
      count(1) -- Count the number of events for each host
    FROM
       bootcamp.web_events we 
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01') -- Filter for events on the specific date
    GROUP BY
      host, -- Group by host
      CAST(date_trunc('day', event_time) AS DATE) -- Group by the truncated date
  )
-- Select the combined results from the CTEs
SELECT
  COALESCE(y.host, t.host) AS host, -- Use the host from 'yesterday' if it exists, otherwise use the host from 'today'
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist -- If host_activity_datelist is not null, prepend today's event date
    ELSE ARRAY[t.event_date] -- If host_activity_datelist is null, create a new array with today's event date
  END AS host_activity_datelist,
  DATE('2023-01-01') AS DATE -- Set the date for the record to '2023-01-01'
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
