INSERT INTO malmarzooq80856.hosts_cumulated
WITH today AS (
-- Select host and event date for events occurring on 2023-01-01
    SELECT
        host,
        CAST(date_trunc('day', we.event_time) AS DATE) AS event_date
    FROM bootcamp.web_events we
    WHERE DATE_TRUNC('day', we.event_time) = DATE('2023-01-01')
    GROUP BY 1, 2
),
yesterday AS (
-- Select data from hosts_cumulated for the previous day
    SELECT *
    FROM malmarzooq80856.hosts_cumulated
    WHERE date = DATE('2022-12-31')
)
-- Combine today's events with yesterday's data
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL
            THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    COALESCE(y.date + 1, t.event_date) AS date
FROM yesterday y
FULL OUTER JOIN today t ON y.host = t.host
