INSERT INTO user_devices_cumulated
SELECT
    we.user_id,
    d.browser_type,
    ARRAY_AGG(we.event_date ORDER BY we.event_date DESC) as dates_active,
    CURRENT_DATE as date
FROM web_events we
JOIN devices d ON we.device_id = d.device_id
GROUP BY we.user_id, d.browser_type