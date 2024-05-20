-- Reduced Host Fact Array Implementation (query_8.sql)
-- This query incrementally populates the host_activity_reduced table from daily_web_metrics.

INSERT INTO alissabdeltoro.host_activity_reduced (host, metric_name, metric_array, month_start)

-- Step 1: Retrieve data for the previous month from host_activity_reduced
WITH yesterday AS (
    SELECT * 
    FROM alissabdeltoro.host_activity_reduced
    WHERE month_start = '2023-08-01'  -- Filter data for the previous month
),

-- Step 2: Retrieve data for the current month from bootcamp.web_events
today AS (
    SELECT 
        we.host,
        CASE 
            WHEN we.url = '/signup' THEN 'visited_signup'
            WHEN we.url = '/' THEN 'visited_homepage'
        END AS metric_name,
        COUNT(*) AS metric_value, -- Assuming you want to count occurrences
        CAST(date_trunc('day', we.event_time) AS DATE) AS event_date
    FROM bootcamp.web_events we
    WHERE we.event_time >= DATE '2023-08-01' -- Filter data for the current day
      AND we.event_time < DATE '2023-08-02' -- Filter data for the current day
    GROUP BY we.host,
             CASE 
                 WHEN we.url = '/signup' THEN 'visited_signup'
                 WHEN we.url = '/' THEN 'visited_homepage'
             END,
             CAST(date_trunc('day', we.event_time) AS DATE)
)

-- Step 3: Select fields for incremental population and insert into host_activity_reduced table
SELECT 
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE '2023-08-01', t.event_date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
    '2023-08-01' AS month_start
FROM today t
FULL OUTER JOIN yesterday y
    ON t.host = y.host AND t.metric_name = y.metric_name
