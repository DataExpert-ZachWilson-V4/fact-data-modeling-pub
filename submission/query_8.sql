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
    GROUP BY CAST(event_time AS DATE), host, CASE WHEN url = '/' THEN 'visited_home' WHEN url = '/blog' THEN 'visited_blog' ELSE 'visited_other' END
),
yesterday AS (
    SELECT *
    FROM tharwaninitin.host_activity_reduced
    WHERE month_start = '2023-08-01'
),
today AS (
    SELECT *
    FROM daily_web_metrics
    WHERE date = DATE('2023-08-02')
)
SELECT
    COALESCE(today.host, yesterday.host) AS host,
    COALESCE(today.metric_name, yesterday.metric_name) AS metric_name,
    COALESCE(yesterday.metric_array, REPEAT(NULL, CAST(DATE_DIFF('DAY', DATE('2023-08-01'), today.date) AS INTEGER))) || ARRAY[today.metric_value] AS metric_array,
    '2023-08-01' AS month_start
FROM today
FULL OUTER JOIN yesterday ON today.host = yesterday.host AND today.metric_name = yesterday.metric_name