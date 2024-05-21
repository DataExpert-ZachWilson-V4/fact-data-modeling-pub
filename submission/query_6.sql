-- query_6 Host Activity Datelist Implementation
-- query to incrementally populate the hosts_cumulated table from the web_events table.
-- Inserting data into the hosts_cumulated table

INSERT INTO
  aayushi.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      aayushi.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31')  -- Selecting data for the previous day
  ),  -- CTE to fetch data for the previous day (2022-12-31)

  today AS (
    SELECT
        host                                   
      , CAST(date_trunc('day', event_time) AS DATE) AS event_date  -- Truncating event_time to get the event_date
      , COUNT(1) AS activity_count  -- Counting the number of events for each host and date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01')  --current day for date
    GROUP BY
        host 
      , CAST(date_trunc('day', event_time) AS DATE)  
  )  -- CTE to fetch data for the current day (2023-01-01)

-- Main query to insert aggregated data into hosts_cumulated table
SELECT
    COALESCE(y.host, t.host) AS host   -- Handling NULL values with COALESCE
  , CASE
        -- Populating date_list array, if user was active yesterday, append yesterday's dates to today's dates_active array
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]  -- If host was not active yesterday, set today's date as the only activity date
    END AS host_activity_datelist
  , DATE('2023-01-01') AS DATE  -- Setting the date as 2023-01-01 for all records  for simplified view
FROM
  yesterday y
FULL OUTER JOIN today t 
    ON y.host = t.host



-- did the incremental till '2023-01-07'