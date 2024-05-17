INSERT INTO luiscoelho37431.hosts_cumulated
WITH yesterday AS (
    SELECT *
    FROM luiscoelho37431.hosts_cumulated
    WHERE date = DATE('2020-12-31')
),
today AS (
    SELECT
        host,
        CAST(event_time AS DATE) AS event_date,
        COUNT(1)
    FROM bootcamp.web_events
    WHERE CAST(event_time as DATE) = DATE('2021-01-01')
    GROUP BY 1, 2
)
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL
            THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    COALESCE(y.date + INTERVAL '1' DAY, t.event_date) AS date
FROM yesterday AS y
FULL OUTER JOIN today AS T ON y.host = t.host
