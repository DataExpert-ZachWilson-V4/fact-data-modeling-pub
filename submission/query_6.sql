INSERT INTO host_cummulated

WITH 
yesterday AS (
    SELECT 
    *
    FROM carloslaguna21592.host_cummulated
    WHERE date = DATE('2023-01-01')
),
today AS (
    SELECT
        host, 
        ARRAY_AGG(
            DISTINCT CAST(DATE_TRUNC('day', event_time) AS DATE) 
        )  AS host_activity_datelist,
        CAST(DATE_TRUNC('day', event_time) AS DATE) AS date
    FROM bootcamp.web_events
    WHERE 
        DATE_TRUNC('day', event_time) = DATE('2023-01-02')
    GROUP BY host, DATE_TRUNC('day', event_time)
)

SELECT  
    COALESCE(y.host, t.host) AS host,
    CASE 
        WHEN y.host_activity_datelist IS NULL THEN t.host_activity_datelist
        ELSE t.host_activity_datelist || y.host_activity_datelist
    END AS host_activity_datelist,
    t.date AS date
FROM yesterday y
FULL OUTER JOIN today t
ON y.host = t.host
LIMIT 20