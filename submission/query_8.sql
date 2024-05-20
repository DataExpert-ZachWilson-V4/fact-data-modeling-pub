INSERT INTO tharwaninitin.host_activity_reduced
-- Simulating daily_web_metrics
WITH daily_web_metrics AS (
    SELECT CAST(event_time AS DATE) AS date,
        host,
        CASE
            WHEN url = '/' THEN 'visited_home'
            WHEN url = '/blog' THEN 'visited_blog'
            ELSE 'visited_other'
        END AS metric_name,
        COUNT(*) AS metric_value
    FROM bootcamp.web_events
    GROUP BY 1,2,3
)
SELECT host,
    metric_name,
    ARRAY_AGG(metric_value) AS metric_array,
    CAST(DATE_TRUNC('month', date) AS DATE) AS month_start
FROM daily_web_metrics
GROUP BY host, metric_name, CAST(DATE_TRUNC('month', date) AS DATE)
ORDER BY 4,1,2