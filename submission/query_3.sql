INSERT INTO jlcharbneau.user_devices_cumulated
WITH yesterday AS (
    SELECT *
    FROM jlcharbneau.user_devices_cumulated
    WHERE date = date('2021-01-18')
    ), today AS (
SELECT
    we.user_id,
    d.browser_type,
    ARRAY_AGG(DISTINCT date_trunc('day', we.event_time)) AS dates_active
FROM
    bootcamp.devices d
    JOIN
    bootcamp.web_events we ON d.device_id = we.device_id
WHERE date_trunc('day', we.event_time) = DATE('2023-08-25')
GROUP BY
    we.user_id, d.browser_type
    )
SELECT
    COALESCE(yesterday.user_id, today.user_id) AS user_id,
    COALESCE(yesterday.browser_type, today.browser_type) AS browser_type,
    COALESCE(today.dates_active, yesterday.dates_active) AS dates_active,
    CURRENT_DATE AS date
FROM
    yesterday
    FULL OUTER JOIN today ON yesterday.user_id = today.user_id AND yesterday.browser_type = today.browser_type