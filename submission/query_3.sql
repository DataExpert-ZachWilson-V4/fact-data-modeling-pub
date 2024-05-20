INSERT INTO
  nikhilsahni.user_devices_cumulated
WITH
  combined AS (
    SELECT
      we.user_id AS user_id,
      we.device_id AS device_id,
      d.browser_type AS browser_type,
      DATE(DATE_TRUNC('day', event_time)) AS event_date
    FROM
      bootcamp.web_events AS we
      LEFT JOIN bootcamp.devices AS d ON we.device_id = d.device_id
  ),
  dupes AS (
    SELECT
      user_id,
      browser_type,
      event_date,
      COUNT(*) AS cnt
    FROM
      combined
    GROUP BY
      user_id,
      browser_type,
      event_date
  ),
  deduped AS (
    SELECT
      user_id,
      browser_type,
      event_date
    FROM
      dupes
  ),
  yesterday AS (
    SELECT
      *
    FROM
      nikhilsahni.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31')
  ),
  today AS (
    SELECT
      *
    FROM
      deduped
    WHERE
      event_date = DATE('2023-01-01')
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.user_id IS NULL THEN ARRAY[t.event_date]
    WHEN y.user_id IS NOT NULL
    AND t.user_id IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    WHEN y.user_id IS NOT NULL
    AND t.user_id IS NULL THEN y.dates_active
  END AS dates_active,
  DATE('2023-01-01') AS DATE
FROM
  yesterday AS y
  FULL OUTER JOIN today AS t ON y.user_id = t.user_id
  AND y.browser_type = t.browser_type
