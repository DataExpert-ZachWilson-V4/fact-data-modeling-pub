INSERT INTO luiscoelho37431.hosts_cumulated
-- Inserting data into the 'hosts_cumulated' table

WITH yesterday AS (
    -- Creating a temporary table 'yesterday' to store data from 'hosts_cumulated' for the date '2020-12-31'
    SELECT *
    FROM luiscoelho37431.hosts_cumulated
    WHERE date = DATE('2020-12-31')
),
today AS (
    -- Creating a temporary table 'today' to store data from 'web_events' for the date '2021-01-01'
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
    -- Selecting the host from either 'yesterday' or 'today' table, whichever is not null
    CASE
        WHEN y.host_activity_datelist IS NOT NULL
            THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    -- Creating an array of host activity dates by combining the dates from 'yesterday' and 'today' tables
    COALESCE(y.date + INTERVAL '1' DAY, t.event_date) AS date
    -- Selecting the date as the next day of 'yesterday' or the date from 'today' table, whichever is not null
FROM yesterday AS y
FULL OUTER JOIN today AS T ON y.host = t.host
-- Performing a full outer join on 'yesterday' and 'today' tables based on the host column
