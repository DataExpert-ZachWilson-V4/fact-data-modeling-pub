INSERT INTO hosts_cumulated
WITH yesterday AS 
(
    SELECT *
    FROM hosts_cumulated
    WHERE date = DATE('2023-01-06')
),

today AS 
(
    SELECT *
    FROM bootcamp.web_events
    WHERE DATE(event_time) = DATE('2023-01-07') 
)
SELECT DISTINCT 
    COALESCE(y.host, t.host) AS host, 
    CASE 
        WHEN y.host_activity_datelist IS NOT NULL THEN
            ARRAY[DATE(t.event_time)] || y.host_activity_datelist 
        ELSE 
            ARRAY[DATE(t.event_time)]
    END AS host_activity_datelist,
    DATE('2023-01-07') AS date  
FROM 
    yesterday y
FULL OUTER JOIN 
    today t 
ON 
    y.host = t.host
