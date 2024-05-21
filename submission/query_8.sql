WITH monthly_metrics AS (
    SELECT
        host,
        metric_name,
        -- Aggregate metric values into an array, ordered by metric_date
        ARRAY_AGG(metric_value ORDER BY metric_date) as metric_array,
        -- Get the start of the month for each metric_date
        DATE_TRUNC('month', metric_date) as month_start
    FROM bootcamp.daily_web_metrics
    -- Group by host, metric_name, and the start of the month
    GROUP BY host, metric_name, DATE_TRUNC('month', metric_date)
)
INSERT INTO host_activity_reduced (host, metric_name, metric_array, month_start)
SELECT
    host,
    metric_name,
    metric_array,
    -- Convert the month_start date to a string
    CAST(month_start AS varchar) as month_start
FROM bootcamp.monthly_metrics
