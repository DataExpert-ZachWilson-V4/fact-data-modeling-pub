-- As shown in the fact data modeling day 2 lab, write a query to incrementally populate the `hosts_cumulated` table from the `web_events` table.

-- Insert the results of the query into the `hosts_cumulated` table
INSERT INTO raj.hosts_cumulated
WITH
  -- Select data from the previous day's records in `hosts_cumulated`
  yesterday AS (
    SELECT
      host,
      host_activity_datelist,
      date
    FROM
      raj.hosts_cumulated
    WHERE
      date = DATE('2023-02-02')  -- Previous day's date
  ),
  -- Select today's event data from the `web_events` table
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-02-03')  -- Today's date
    GROUP BY 1,2 -- Group by host and event date
  )
-- Combine data from yesterday and today
SELECT
  COALESCE(y.host, t.host) AS host,  -- Use host from either yesterday or today
  CASE
    -- If both yesterday's and today's records exist, concatenate today's event date with the existing datelist
    WHEN y.host_activity_datelist IS NOT NULL AND t.event_date IS NOT NULL THEN
      ARRAY[t.event_date] || y.host_activity_datelist
    -- If only yesterday's record exists, keep the existing datelist
    WHEN y.host_activity_datelist IS NOT NULL AND t.event_date IS NULL THEN
      y.host_activity_datelist
    -- If only today's record exists, create a new datelist with today's date
    WHEN y.host_activity_datelist IS NULL THEN
      ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-02-03') AS date  -- Assign today's date to the record
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host  -- Full outer join to include all hosts from both yesterday and today
