INSERT INTO 
  derekleung.web_users_cumulated
-- CTE layers:
-- Situation: web_users_cumulated has been filled up to 2023-01-02, now filling 2023-01-03 incrementally
-- yesterday: web_user_cumulated table with 2nd most recent info
-- today: summarized data of today with same format as web_users_cumulated for easy adaptation
-- SELECT: join yesterday and today and coalesce/concatenate appropriate entries to show updated results
WITH
  yesterday AS (
    SELECT
      *
    FROM
      derekleung.web_users_cumulated
    WHERE
      DATE = DATE('2023-01-02')
  ),
  today AS (
    SELECT
      we.user_id,
  --browser_type: taken from derekleung.devices
      d.browser_type,
  --use date_trunc to get only date instead of full timestamp
      CAST(date_trunc('day', we.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      derekleung.web_events we
    JOIN
      derekleung.devices d
    ON
      we.device_id = d.device_id
    WHERE
      date_trunc('day', we.event_time) = DATE('2023-01-03')
    GROUP BY
      we.user_id,
      d.browser_type,
      CAST(date_trunc('day', we.event_time) AS DATE)
  )
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-03') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id
