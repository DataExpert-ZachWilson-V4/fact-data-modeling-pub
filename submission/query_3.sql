INSERT INTO mposada.user_devices_cumulated 
-- Step 1: Get yesterday's data from user_devices_cumulated table for 2023-01-01
WITH yesterday AS (
    SELECT
      *
    FROM
      mposada.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-01')
),

-- Step 2: Get today's web events, join with devices, group by user_id, event_date, and browser_type
today AS (
    SELECT
      user_id,
      browser_type,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM
      bootcamp.web_events w
    LEFT JOIN bootcamp.devices d ON d.device_id = w.device_id
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-02')
    GROUP BY
      user_id,
      CAST(date_trunc('day', event_time) AS DATE),
      browser_type
)

-- Step 3: Combine yesterday's and today's data
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-02') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id
