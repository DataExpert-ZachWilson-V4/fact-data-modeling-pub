INSERT INTO host_activity_reduced (host, metric_name, metric_array, month_start)

WITH yesterday AS (
    SELECT *
    FROM alissabdeltoro.host_activity_reduced
    WHERE month_start = '2023-08-01'  -- Filter data for the previous month
),
today AS (
    SELECT
        host,
        metric_name,
        SUM(metric_value) AS metric_value,
        date AS event_date
    FROM alissabdeltoro.daily_web_metrics
    WHERE date >= DATE '2023-08-01' -- Filter data for the current month
      AND date < DATE '2023-09-01' -- Filter data for the current month
    GROUP BY
        host,
        metric_name,
        date
)
SELECT 
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE '2023-08-01', t.event_date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
    '2023-08-01' AS month_start
FROM today t
FULL OUTER JOIN yesterday y
    ON t.host = y.host AND t.metric_name = y.metric_name
