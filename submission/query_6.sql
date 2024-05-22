-- query_6
INSERT INTO qhamzah.hosts_cumulated
WITH
  -- Select previously backfilled data from the specified date
  yesterday AS (
    SELECT *
      FROM qhamzah.hosts_cumulated
     WHERE date = DATE('2022-12-31')
  ),
  -- Select new data to be loaded by host for the specified date
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS host_activity_datelist
      FROM bootcamp.web_events
     WHERE date_trunc('day', event_time) = DATE('2023-01-01')
     GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
  )

-- Combine data from 'yesterday' and 'today'
SELECT
  COALESCE(y.host, t.host) AS host,
  -- Append host_activity_datelist from 'today' if it exists, otherwise create a single-item array with host_activity_datelist from 'today'
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
    ELSE ARRAY[t.host_activity_datelist]
  END AS host_activity_datelist,
  DATE('2023-01-01') AS date
  FROM yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
