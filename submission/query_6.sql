INSERT INTO hosts_cumulated -- Get the previous day's data
  WITH yesterday AS (
    SELECT *
    FROM hosts_cumulated
    WHERE DATE = DATE('2023-01-01') - INTERVAL '1' DAY
  ),
  today AS (
    SELECT host,
      -- Cast timestamp to date
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      -- Group by host and date and also get event counts
      COUNT(1)
    FROM bootcamp.web_events
    WHERE date_trunc('day', event_time) = DATE('2023-01-01')
    GROUP BY host,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT COALESCE(y.host, t.host) AS host,
  -- Create a list of dates when the host was active
  CASE
    -- Old host case
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY [t.event_date] || y.host_activity_datelist -- If the host was active today, add the date to the array
    -- Also covers the new host case for hosts that were active today but not yesterday
    -- and the null case for hosts that were active yesterday but not today
    ELSE ARRAY [t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS DATE
FROM yesterday y
  FULL OUTER JOIN today t ON y.host = t.host