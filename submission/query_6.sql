INSERT INTO sagararora492.hosts_cumulated
WITH yesterday AS (
  SELECT *  -- This accumulates per date in a list of dates for the dates when the host was active
  FROM sagararora492.hosts_cumulated
  WHERE date = DATE('2022-12-31')
  -- If first day, it will be empty.
),
today AS (
  SELECT
    host,
    CAST(date_trunc('day',event_time) AS DATE) AS event_date
  FROM bootcamp.web_events
  WHERE date_trunc('day',event_time) = DATE('2023-01-01')
  GROUP BY 1,2
)
SELECT
  COALESCE(Y.host, T.host) AS host,
  CASE
      WHEN Y.host_activity_datelist IS NOT NULL
        THEN ARRAY[T.event_date] || Y.host_activity_datelist
    -- This is if the host was active yesterday also concats null if there was no activity
      ELSE ARRAY[T.event_date]
  END AS host_activity_datelist,
  COALESCE(Y.date + INTERVAL '1' DAY, T.event_date) AS date
FROM yesterday AS Y
FULL OUTER JOIN today AS T ON Y.host = T.host