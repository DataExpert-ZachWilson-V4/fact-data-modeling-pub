INSERT INTO monthly_host_activity_reduced

WITH metrics_by_host AS (
    SELECT
        host,
        metric_name,
        DATE_TRUNC('month', date) AS month_start,
        ARRAY_AGG(metric_value ORDER BY date) AS metric_array
    FROM
        daily_web_metrics
    GROUP BY
        host, metric_name, month_start
),
filled_metrics AS (
    SELECT
        host,
        metric_name,
        month_start,
        COALESCE(metric_array, ARRAY_FILL(0::INTEGER, ARRAY[30])) AS metric_array
    FROM
        metrics_by_host
)
SELECT
    host,
    metric_name,
    metric_array,
    TO_CHAR(month_start, 'YYYY-MM') AS month_start
FROM
    filled_metrics;
