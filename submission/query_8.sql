-- Query to incrementally populate the host_activity_reduced table from a 
-- daily_web_metrics table
INSERT INTO positivelyamber.host_activity_reduced
WITH 
    yesterday AS (
        SELECT *
        FROM positivelyamber.host_activity_reduced
        WHERE month_start = '2023-01-01'
    ),
    today AS (
        SELECT *
        FROM positivelyamber.daily_web_metrics
        WHERE date = DATE('2023-01-01')
    )

SELECT
    COALESCE(y.host, t.host) as host,
    COALESCE(y.metric_name, t.metric_name) as metric_name,
    COALESCE(
        y.metric_array,
        REPEAT(
            NULL,
            CAST(DATE_DIFF('day', DATE('2023-01-01'), t.date) AS INTEGER)
        )
    ) || ARRAY[t.metric_value] AS metric_array,
    '2023-01-01' AS month_start
FROM yesterday y 
FULL OUTER JOIN today t 
ON y.host = t.host AND y.metric_name = t.metric_name