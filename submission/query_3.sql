-- Write the incremental query to populate the table you wrote the DDL for in the above question from the `web_events` and `devices` tables.
--This should look like the query to generate the cumulation table from the fact modeling day 2 lab.

INSERT INTO ChrisTaulbee.user_devices_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      ChrisTaulbee.user_devices_cumulated
    WHERE
      DATE = DATE('2023-06-30')
  ),
  today AS (
    SELECT
      user_id,
      browser_type,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events we
    LEFT JOIN
      bootcamp.devices d ON we.device_id = d.device_id
    WHERE
      date_trunc('day', event_time) = DATE('2023-07-01')
    GROUP BY
      user_id,
      browser_type,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-07-01') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id

