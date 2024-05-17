INSERT INTO
    dennisgera.hosts_cumulated WITH yesterday AS (
        SELECT
            *
        FROM
            dennisgera.hosts_cumulated
        WHERE
            DATE = DATE('2022-12-31')
    ),
    today AS (
        SELECT
            host,
            CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date,
            COUNT(
                *
            ) AS event_count
        FROM
            bootcamp.web_events
        WHERE
            DATE(event_time) = DATE('2023-01-01')
        GROUP BY
            1,
            2
    )
SELECT
    COALESCE(
        y.host,
        t.host
    ) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY [t.event_date] || y.host_activity_datelist
        ELSE ARRAY [t.event_date]
    END AS dates_active,
    COALESCE(t.event_date, date_add('day', 1, y.date)) AS DATE
FROM
    yesterday y full
    OUTER JOIN today t
    ON y.host = t.host
