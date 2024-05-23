INSERT INTO halloweex.user_devices_cumulated
WITH yesterday AS (SELECT *
                   FROM halloweex.user_devices_cumulated
                   WHERE
    date = DATE ('2022-12-31')
    )
   , today AS (
SELECT
    we.user_id,
    d.browser_type,
    ARRAY_AGG(DISTINCT CAST (we.event_time AS DATE) ORDER BY CAST (we.event_time AS DATE) DESC) AS dates_active,
    date_trunc('day', event_time) AS event_date
FROM
    bootcamp.web_events we
    JOIN
    bootcamp.devices d
ON we.device_id = d.device_id
WHERE date_trunc ('day', we.event_time) = DATE ('2023-01-01')
GROUP BY
    we.user_id, d.browser_type, date_trunc('day', event_time)

    )
SELECT COALESCE(y.user_id, t.user_id)           AS user_id,
       COALESCE(y.browser_type, t.browser_type) AS browser_type,
       CASE
           WHEN y.dates_active IS NOT NULL THEN t.dates_active || y.dates_active
           ELSE t.dates_active
           END                                  AS dates_active, DATE ('2023-01-01') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t
ON y.user_id = t.user_id