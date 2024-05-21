INSERT INTO mposada.hosts_cumulated

-- Define a CTE for data from yesterday
WITH yesterday AS (
    SELECT
      *
    FROM
      mposada.hosts_cumulated
    WHERE
      DATE = DATE('2023-01-01')  -- Filter for records with the date '2023-01-01' in this scenario this is yesterday
),

-- Define a CTE for today's data
today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-02')  -- Filter for records with the date '2023-01-02' in this scenario this is todays date
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)  -- Group by host and event_date
)

-- Select the combined results
SELECT
  COALESCE(y.host, t.host) AS host,  -- Use the host from either yesterday or today
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS dates_active,  -- Combine the dates active from yesterday and today into an array
  DATE('2023-01-02') AS DATE  -- Set the date to '2023-01-02' this is the same as todays date
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host  -- Join yesterday's and today's data on host
