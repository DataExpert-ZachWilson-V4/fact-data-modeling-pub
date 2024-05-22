INSERT INTO host_activity_reduced
WITH 
    yesterday AS (
        SELECT * FROM host_activity_reduced
        WHERE month_start = '2021-01-02'
    ),
    today AS (
        SELECT * FROM daily_web_metrics 
        WHERE DATE = DATE('2021-01-03')
    )
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(
        y.metric_array,
        REPEAT(
            NULL,
            CAST(DATE_DIFF('day', DATE('2021-01-03'), t.date) AS INTEGER) 
        )
    ) || ARRAY [t.metric_value] AS metric_array,
    '2021-01-03' AS month_start
FROM today t FULL
OUTER JOIN yesterday y
ON t.host = y.host AND t.metric_name = y.metric_name
