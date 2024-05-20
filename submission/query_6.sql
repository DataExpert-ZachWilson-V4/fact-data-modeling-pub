-- INSERT DATA INCREMENTALLY INTO THE 'hosts_cumulated' TABLE
-- FROM THE 'web_events' TABLE AS SHOWN IN THE FACT DATA MODELING DAY 2 LAB
INSERT INTO
    hosts_cumulated
WITH
    yesterday AS (
        -- SELECT ALL COLUMNS FROM 'hosts_cumulated' TABLE FOR THE DATE '2023-01-04'
        SELECT
            *
        FROM
            hosts_cumulated
        WHERE
            date = DATE('2023-01-04')
    ),
    today AS (
        -- SELECT HOST AND THE TRUNCATED DATE OF 
        -- EVENT_TIME AS host_activity_datelist
        SELECT
            host,
            ARRAY_AGG(
                DISTINCT CAST(date_trunc('day', event_time) AS DATE)
            ) AS host_activity_datelist
        FROM
            bootcamp.web_events
        WHERE
            -- FILTER EVENTS TO INCLUDE ONLY THOSE FROM '2023-01-05'
            date_trunc('day', event_time) = DATE('2023-01-05')
        GROUP BY
            -- GROUP BY HOST
            host
    )
-- SELECT AND COMBINE DATA FROM 'yesterday' AND 'today' CTEs
SELECT
    -- USE COALESCE TO HANDLE CASES WHERE EITHER 
    -- 'yesterday' OR 'today' HAS A MISSING HOST
    COALESCE(y.host, t.host) AS host,
    -- COMBINE ACTIVITY DATE LISTS FROM 'yesterday' AND 'today'
    CASE
        WHEN y.host_activity_datelist IS NOT NULL 
        THEN t.host_activity_datelist || y.host_activity_datelist
        ELSE t.host_activity_datelist
    END AS host_activity_datelist,
    -- SET THE DATE FOR THE INSERTED RECORDS TO '2023-01-05'
    DATE('2023-01-05') AS date
FROM
    -- PERFORM A FULL OUTER JOIN ON 'host' BETWEEN 'yesterday' AND 'today' CTEs
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host
