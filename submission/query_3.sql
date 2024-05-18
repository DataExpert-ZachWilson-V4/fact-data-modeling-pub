INSERT INTO jlcharbneau.user_devices_cumulated
WITH user_activity AS (
    SELECT
        we.user_id,
        d.browser_type,
        ARRAY_AGG(we.event_time ORDER BY we.event_time DESC) AS dates_active,
        CURRENT_DATE AS date
    FROM
        bootcamp.devices d
        JOIN
        bootcamp.web_events we ON d.device_id = we.device_id
    GROUP BY
        we.user_id, d.browser_type
)
SELECT
    user_id,
    browser_type,
    dates_active,
    date
FROM
    user_activity


