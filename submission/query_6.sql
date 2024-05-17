INSERT INTO jsgomez14.hosts_cumulated
WITH yesterday AS ( -- Define a CTE named yesterday.
  SELECT *  -- This accumulates per date in a list of dates
            -- when the host was active.
            -- This was based on lab 2 query.
  FROM jsgomez14.hosts_cumulated
  WHERE date = DATE('2022-12-31')
  -- If first day, it will be empty.
),
today AS (
  SELECT
    host,
    CAST(date_trunc('day',event_time) AS DATE) AS event_date,
    -- We truncate the event_time to get the date part only.
    -- We cast it to DATE to match the data type of the dates_active column.
    COUNT(1)
    -- Count the number of events per host. 
    -- It won't be used in the final output.
    -- It was just for debugging purposes.
  FROM bootcamp.web_events
  WHERE date_trunc('day',event_time) = DATE('2023-01-01')
  GROUP BY 1,2
)
SELECT
  COALESCE(Y.host, T.host) AS host,
  CASE
      WHEN Y.host_activity_datelist IS NOT NULL
        THEN ARRAY[T.event_date] || Y.host_activity_datelist
    -- If the host was active yesterday, we add today's date to the list.
    -- Concats Null if host has no activity today.
      ELSE ARRAY[T.event_date]
    -- If the host was not active yesterday, we create a new list with today's date.
  END AS host_activity_datelist,
  COALESCE(Y.date + INTERVAL '1' DAY, T.event_date) AS date
FROM yesterday AS Y
FULL OUTER JOIN today AS T ON Y.host = T.host
