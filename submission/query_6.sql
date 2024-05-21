INSERT INTO hosts_cumulated
WITH
yesterday AS (
    SELECT *
    FROM
        hosts_cumulated
    WHERE
        date = DATE('2022-12-31')
),

today AS (
    SELECT
        host,
        CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date,
        COUNT(*) AS count
    FROM
        bootcamp.web_events
    WHERE
        DATE_TRUNC('day', event_time) = DATE('2023-01-01')
    GROUP BY
        host,
        CAST(DATE_TRUNC('day', event_time) AS DATE)
)

SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN
            y.host_activity_datelist IS NOT NULL
            THEN array[t.event_date] || y.host_activity_datelist
        ELSE array[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-01') AS date
FROM
    yesterday AS y
FULL OUTER JOIN today AS t ON y.host = t.host
