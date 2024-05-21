-- This query populates one day of data into daily fact table `hosts_cumulated`
INSERT INTO shashankkongara.hosts_cumulated
-- Retrieves yesterday data of host activities
WITH yesterday AS (
    SELECT
        *
    FROM
        shashankkongara.hosts_cumulated
    WHERE
        date = DATE('2022-12-31')
),

-- Aggregates new events by host and date for today's data from `web_events`
today AS (
    SELECT
        host,
        CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date,
        COUNT(1)
    FROM
        bootcamp.web_events
    WHERE
        DATE_TRUNC('day', event_time) = DATE('2023-01-01')
    GROUP BY
        host,
        CAST(date_trunc('day', event_time) AS DATE)
)

-- Combines 'yesterday' and 'today' data to update the hosts_cumulated table
SELECT
    COALESCE(y.host, t.host) AS host,
    -- Appends new events from today's data to old events in an ARRAY if there are any for each host.
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-01') AS date
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host -- FULL OUTER JOIN ensures to get data from both yesterday and today
