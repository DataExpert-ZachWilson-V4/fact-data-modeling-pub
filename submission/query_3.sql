-- The dates_active array should be a datelist implementation that tracks how many times
-- a user has been active with a given browser_type.

INSERT INTO farahakoum199912722.user_devices_cumulated
WITH yesterday AS (SELECT *
                   FROM farahakoum199912722.user_devices_cumulated
                   WHERE date = DATE ('2022-12-31')
    ),
    today AS (
                SELECT
                    user_id, CAST (date_trunc('day', event_time) AS DATE) AS event_date, browser_type, COUNT (1)
                FROM bootcamp.web_events we
                    JOIN bootcamp.devices d ON we.device_id = d.device_id
                WHERE
                    date_trunc('day', event_time) = DATE ('2023-01-01')
                GROUP BY
                    user_id,
                    CAST (date_trunc('day', event_time) AS DATE),
                    browser_type
    )

SELECT COALESCE(y.user_id, t.user_id) AS user_id,
       COALESCE(y.browser_type, t.browser_type) AS browser_type,
       CASE
           WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
           ELSE ARRAY[t.event_date]
           END                        AS dates_active,
       DATE ('2023-01-01') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t
        ON y.user_id = t.user_id