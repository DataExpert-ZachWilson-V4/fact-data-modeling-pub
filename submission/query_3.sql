-- 
INSERT INTO user_devices_cumulated
WITH yesterday AS (
  SELECT *
  FROM user_devices_cumulated
  WHERE date = DATE('2022-12-31')
),
today AS (
  SELECT
    w.user_id,
    d.browser_type,
    DATE(w.event_time) AS event_date,
    COUNT(1) AS count
  FROM bootcamp.web_events w
  LEFT JOIN bootcamp.devices d ON w.device_id = d.device_id
  WHERE DATE(w.event_time) = DATE('2023-01-01')
  GROUP BY
    w.user_id,
    d.browser_type,
    DATE(w.event_time)
)
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL
      THEN ARRAY[t.event_date] || y.dates_active
    ELSE
      ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-01') AS date
FROM yesterday y
FULL OUTER JOIN today t ON y.user_id = t.user_id

-- Test the output table
-- SELECT *
-- FROM user_devices_cumulated
-- WHERE
--   user_id IN (-1997364366, -1936905104, -1809293094, 889259381, -27044480)
-- ORDER BY user_id, date
