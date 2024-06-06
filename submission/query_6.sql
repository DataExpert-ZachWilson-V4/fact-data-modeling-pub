-- Inserting data into the 'hosts_cumulated' table
INSERT INTO bhakti.hosts_cumulated
-- Using a common table expression (CTE) to define the 'yesterday' subset
WITH yesterday AS (
    SELECT *
    FROM bhakti.hosts_cumulated
    WHERE DATE = DATE('2023-01-02')
),
-- Using a CTE to define the 'today' subset
today AS (
    SELECT
        host,
        CAST(date_trunc('day', event_time) AS DATE) AS event_date,
        COUNT(1)
    FROM bootcamp.web_events
    WHERE date_trunc('day', event_time) = DATE('2023-01-03')
    GROUP BY host, CAST(date_trunc('day', event_time) AS DATE)
)
-- Selecting data from the 'yesterday' and 'today' subsets
SELECT
    COALESCE(y.host, t.host) AS host,
    CASE
        WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
        ELSE ARRAY[t.event_date]
    END AS host_activity_datelist,
    DATE('2023-01-03') AS DATE
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host
