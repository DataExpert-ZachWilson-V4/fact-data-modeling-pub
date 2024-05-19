INSERT INTO
    hosts_cumulated
with
    yesterday as (
        select
            *
        from
            hosts_cumulated
        where
            date = DATE('2023-01-01')
    ),
    today as (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS host_activity_datelist,
            event_time AS date
        FROM
            bootcamp.web_events we
        WHERE
            date_trunc('day', event_time) = DATE('2023-01-02')
        GROUP BY
            host,
            event_time,
            CAST(date_trunc('day', event_time) AS DATE)
    )
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.host_activity_datelist] || y.host_activity_datelist
        ELSE ARRAY[t.host_activity_datelist]
    END AS host_activity_datelist,
    DATE('2023-01-02') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host