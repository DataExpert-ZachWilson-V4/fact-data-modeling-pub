INSERT INTO saismail.user_devices_cumulated
WITH reduced AS (
SELECT
  w.user_id AS user_id,
  d.browser_type AS browser_type,
  NULL as dates_active,
  CAST(w.event_time AS DATE) AS "date"
  FROM 
  bootcamp.web_events w 
  JOIN bootcamp.devices d 
  ON w.device_id = d.device_id
),
yesterday AS (
    SELECT
      *
    FROM
      saismail.user_devices_cumulated
    WHERE
      "date"= DATE('2023-01-02')
  ),
  today AS (
    SELECT
      user_id,
      browser_type,
      "date",
      COUNT(1)
    FROM
      reduced
    WHERE
      "date" = DATE('2023-01-03')
    GROUP BY
      user_id, browser_type,
      "date"
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t."date"] || y.dates_active
    ELSE ARRAY[t."date"]
  END AS dates_active,
  t."date" as "date"
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id