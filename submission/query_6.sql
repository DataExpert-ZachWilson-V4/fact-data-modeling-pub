INSERT INTO
    hosts_cumulated
WITH
--previously loaded data
    yesterday AS (
        SELECT
            *
        FROM
            hosts_cumulated
        WHERE
            date = DATE('2022-12-31')
    ),
    --count the number of events for new data by host and date
    today AS (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) as event_date,
            COUNT(1)
        FROM
            bootcamp.web_events
        WHERE
            date_trunc('day', event_time) = DATE('2023-01-01')
        GROUP BY
            host,
            CAST(date_trunc('day', event_time) AS DATE)
    )
--append host_activity_datelist if it exists, else create single-item array with date
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN CONCAT(ARRAY[t.event_date], y.host_activity_datelist)
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-01') AS date
FROM
    yesterday AS y
    FULL OUTER JOIN today AS t ON t.host = y.host