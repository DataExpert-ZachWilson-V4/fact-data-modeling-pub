
INSERT INTO bhakti.web_users_cumulated
WITH
    yesterday AS (
        SELECT
            *
        FROM
            bhakti.web_users_cumulated
        WHERE
            DATE = DATE('2022-01-02')
    ),
    today AS (
        SELECT we.user_id, d.browser_type, d.device_type, ARRAY_AGG(CAST(DATE_TRUNC('day', we.event_time) AS DATE) ORDER BY we.event_time DESC) AS dates_active
        FROM bootcamp.web_events we
        JOIN bootcamp.devices d ON we.device_id = d.device_id
        GROUP BY we.user_id, d.browser_type, d.device_type
    )
SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        WHEN y.dates_active IS NOT NULL THEN t.dates_active || y.dates_active
        ELSE t.dates_active
    END AS dates_active,
    DATE('2023-01-03') AS date
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type