INSERT INTO akshayjainytl54781.hosts_cumulated
WITH
  yesterday AS ( -- CTE to get yesterday's data
    SELECT
      *
    FROM
      akshayjainytl54781.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31')
  ),
  today AS ( -- CTE to get today's data
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date -- Casting for easy viewability
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01')
    GROUP BY
    -- Group by both columns
      1,
      2
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    -- Case 1 -- We have cumulated data from yesterday. In that case, today's data is at the first index, concatendated with the existing data
    -- This way, the array is in a reverse chronological order of days in the month. Very easy to analyze and deduce.
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    -- Case 2 -- No prior data. This happens for the 1st day of the month
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date -- Hard coding to the 1st day of the month
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host -- Full outer join to get both 'yesterday' and 'today' data