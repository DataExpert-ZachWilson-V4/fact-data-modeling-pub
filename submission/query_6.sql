-- Incremental query to populate hosts_cumulated from the web_events and devices tables

INSERT INTO shruthishridhar.hosts_cumulated
WITH
    yesterday AS (
        SELECT * FROM shruthishridhar.hosts_cumulated
        WHERE DATE = DATE('2021-01-02') -- earliest date in web_events table
    ),
    today AS (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date,
            COUNT(1)
        FROM bootcamp.web_events events
        WHERE date_trunc('day', event_time) = DATE('2021-01-03')    -- get date alone from event time
        GROUP BY 1, 2    -- group by user_id and date
    )
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL AND t.event_date IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist -- if both are there, combine with today's first followed by yesterday's list
        WHEN y.host_activity_datelist IS NOT NULL THEN y.host_activity_datelist -- if today's date is null, use yesterday's list
        WHEN t.event_date IS NOT NULL THEN ARRAY[t.event_date]  -- if yesterday's datelist is null, use today's
    END AS host_activity_datelist,
    DATE('2021-01-03') AS date
FROM yesterday y
FULL OUTER JOIN today t
ON y.host = t.host