INSERT INTO user_devices_cumulated
  
WITH user_browser_activity AS (
    SELECT
        d.user_id,
        d.browser_type,
        ARRAY_AGG(DISTINCT e.date) AS dates_active,
        CURRENT_DATE AS date
    FROM
        web_events e
    JOIN
        devices d ON e.device_id = d.device_id
    GROUP BY
        d.user_id, d.browser_type
)

SELECT
    user_id,
    browser_type,
    dates_active,
    date
FROM
    user_browser_activity
