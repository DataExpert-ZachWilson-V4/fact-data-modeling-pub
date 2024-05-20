INSERT INTO
  phabrahao.user_devices_cumulated
WITH
  new_data AS (
    SELECT
      user_id,
      browser_type,
      date(event_time) AS DATE
    FROM
      bootcamp.web_events we
      LEFT JOIN bootcamp.devices d ON we.device_id = d.device_id
    WHERE
      date(event_time) = date('2021-01-04')
    GROUP BY
      1,2,3
  )
SELECT
  COALESCE(udc.user_id, dl.user_id) AS user_id,
  COALESCE(udc.browser_type, dl.browser_type) AS browser_type,
  CASE
    WHEN udc.dates_active IS NOT NULL THEN ARRAY[dl.date] || udc.dates_active
    ELSE ARRAY[dl.date]
  END AS dates_active,
  COALESCE(dl.date, DATE_ADD('day', 1, udc.date)) AS DATE
FROM
  phabrahao.user_devices_cumulated udc
  FULL OUTER JOIN new_data dl ON udc.user_id = dl.user_id
  AND udc.browser_type = dl.browser_type
  AND udc.date = date('2021-01-03')