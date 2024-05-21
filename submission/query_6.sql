-- Let's start populating our table from 1st of Jan 2023
INSERT INTO andreskammerath.hosts_cumulated
WITH
    yesterday AS (
        SELECT *
        FROM andreskammerath.hosts_cumulated
        WHERE DATE = DATE('2022-12-31')
    ),
    today AS (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            COUNT(1)
        FROM bootcamp.web_events
        WHERE date_trunc('day', event_time) = DATE('2023-01-01')
        GROUP BY
            host,
            CAST(date_trunc('day', event_time) AS DATE)
    )
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-01') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host

-- ====================================
-- Now let's populate a one more year to validate everything is as expected

INSERT INTO andreskammerath.hosts_cumulated
WITH
    yesterday AS (
        SELECT *
        FROM andreskammerath.hosts_cumulated
        WHERE DATE = DATE('2023-01-01')
    ),
    today AS (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            COUNT(1)
        FROM bootcamp.web_events
        WHERE date_trunc('day', event_time) = DATE('2023-01-02')
        GROUP BY
            host,
            CAST(date_trunc('day', event_time) AS DATE)
    )
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-02') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host