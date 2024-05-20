INSERT INTO
    phabrahao.hosts_cumulated
WITH
    today AS (
        SELECT
            host,
            date(event_time) AS DATE
        FROM
            bootcamp.web_events
        WHERE
            date(event_time) = date('2021-01-05')
        GROUP BY
            1,
            2
    ),
    yesterday AS (
        SELECT
            *
        FROM
            phabrahao.hosts_cumulated
        WHERE
            DATE = date('2021-01-04')
    )
SELECT
    COALESCE(hc.host, t.host) AS host,
    CASE
        WHEN hc.host_activity_datelist IS NOT NULL THEN ARRAY[t.date] || hc.host_activity_datelist
        ELSE ARRAY[t.date]
    END AS dates_active,
    COALESCE(t.date, DATE_ADD('day', 1, hc.date)) AS DATE
FROM
    yesterday hc
    FULL OUTER JOIN today t ON hc.host = t.host


