-- Incrementally populate the hosts_cumulated table from the web_events table
INSERT INTO
  raniasalzahrani.hosts_cumulated
WITH
  -- Fetch current day activity from the web_events table
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      DATE '2022-01-05' AS DATE -- Set the date to the current date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE '2022-01-05' -- Filter for events on 2020-01-05
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  ),
  -- Retrieve all records from the hosts_cumulated table for the previous day
  yesterday AS (
    SELECT
      host,
      host_activity_datelist,
      DATE
    FROM
      raniasalzahrani.hosts_cumulated
    WHERE
      DATE = DATE '2022-01-04'
  )
  -- Combine yesterday's and today's records, ensuring all combinations are included
SELECT
  COALESCE(y.host, t.host) AS host, -- Use host from today if available, otherwise from yesterday
  -- Update host_activity_datelist by adding today's date to the existing array if it exists
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE '2022-01-05' AS DATE -- Set the date to the current date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
