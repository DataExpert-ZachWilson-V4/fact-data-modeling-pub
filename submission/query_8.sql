WITH
    yesterday AS (
        SELECT
            host,
            metric_name,
            metric_array,
            month_start
        FROM
            xeno.host_activity_reduced
        WHERE
            month_start = '2023-01-01'
    ),
    today AS (
        SELECT
            host,
            metric_name,
            metric_value,
            month_start
        FROM
            xeno.daily_web_metrics
        WHERE
            month_start = '2023-01-02'
    )
-- Combine the data from the previous and current day
SELECT
    COALESCE(y.host, t.host) AS host,
    COALESCE(y.metric_name, t.metric_name) AS metric_name,
    COALESCE(y.metric_array, ARRAY[NULL]) || ARRAY[t.metric_value] AS metric_array,
    '2023-01-01' AS month_start
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host AND y.metric_name = t.metric_name