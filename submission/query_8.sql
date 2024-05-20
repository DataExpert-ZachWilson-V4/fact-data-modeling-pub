-- Reduced Host Fact Array Implementation (query_8.sql)
-- This query incrementally populates the host_activity_reduced table from daily_web_metrics.
INSERT INTO alissabdeltoro.host_activity_reduced
-- Retrieve data for the previous day from host_activity_reduced
WITH previous_day AS (
    SELECT 
        host,
        metric_name,
        metric_array,
        month_start
    FROM alissabdeltoro.host_activity_reduced
    WHERE month_start = '2023-08-02'  -- Adjust this date as needed for the initial setup
),

-- Retrieve data for the first day of the month
first_day AS (
    SELECT 
        we.host AS host,
        dwm.metric_name AS metric_name,
        SUM(dwm.metric_value) AS metric_value,
        dwm.date AS date
    FROM bootcamp.web_events we
    LEFT JOIN alissabdeltoro.daily_web_metrics dwm
      ON we.user_id = dwm.user_id AND we.event_time = dwm.date
    WHERE dwm.date = DATE '2023-08-01'  -- The first day of the month
    GROUP BY we.host, dwm.metric_name, dwm.date
),

-- Retrieve data for the current day from daily_web_metrics
current_day AS (
    SELECT 
        we.host AS host,
        dwm.metric_name AS metric_name,
        SUM(dwm.metric_value) AS metric_value,
        dwm.date AS date
    FROM bootcamp.web_events we
    LEFT JOIN alissabdeltoro.daily_web_metrics dwm
      ON we.user_id = dwm.user_id AND we.event_time = dwm.date
    WHERE dwm.date = DATE '2023-08-03'  -- Adjust this date as needed for testing
    GROUP BY we.host, dwm.metric_name, dwm.date
)

-- Insert data for subsequent days
SELECT 
    COALESCE(cd.host, pd.host) AS host,  -- Use the current day's host if available, otherwise, use the previous day's host
    COALESCE(cd.metric_name, pd.metric_name) AS metric_name,  -- Use the current day's metric name if available, otherwise, use the previous day's metric name
    CASE 
        WHEN pd.metric_array IS NOT NULL THEN 
            ARRAY[COALESCE(cd.metric_value, 0)] || pd.metric_array 
        ELSE 
            ARRAY[COALESCE(cd.metric_value, 0)] 
    END AS metric_array,  -- Merge the metric arrays from both days
    '2023-08-01' AS month_start  -- Adjust this date as needed for testing
FROM current_day cd
FULL OUTER JOIN previous_day pd
    ON cd.host = pd.host AND cd.metric_name = pd.metric_name
