-- 
INSERT INTO hosts_cumulated
WITH yesterday AS (
  SELECT *
  FROM hosts_cumulated
  WHERE date = DATE('2022-12-31')
),
today AS (
  SELECT
    host,
    DATE(event_time) AS event_date,
    COUNT(1) AS count
  FROM bootcamp.web_events
  WHERE DATE(event_time) = DATE('2023-01-01')
  GROUP BY
    host,
    DATE(event_time)
)
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL
      THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE
      ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS date
FROM yesterday y
FULL OUTER JOIN today t ON y.host = t.host

-- Test the output table
-- SELECT *
-- FROM ibrahimsherif.hosts_cumulated
-- WHERE host = 'www.eczachly.com'
