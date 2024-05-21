-- Insert one day's worth of data into the monthly host_activity_reduced table for the given month
-- In practice this query would either need to be run as an INSERT OVERWRITE (which is not currently supported in Trino), or
-- would need to be followed by the following DELETE query
-- delete from host_activity_reduced
-- where cardinality(metric_array) < 2 -- Here 2 is the number of days currently represented in the table (date_diff from start of month to last day entered)


-- Insert the updated metrics into the monthly table
INSERT INTO host_activity_reduced
-- Define the daily metrics calculation
WITH daily_web_metrics AS (
    SELECT
        host,
        CASE
            WHEN url = '/' THEN 'visited_home_page'
            WHEN url = '/signup' THEN 'visited_signup'
            END AS metric_name,
        COUNT(CASE WHEN url IN ('/', '/signup') THEN 1 END) AS metric_value,
        CAST(event_time AS DATE) AS date
FROM bootcamp.web_events
GROUP BY host,
    CASE
    WHEN url = '/' THEN 'visited_home_page'
    WHEN url = '/signup' THEN 'visited_signup'
END,
             CAST(event_time AS DATE)
),

-- Select existing data for the month
yesterday AS (
    SELECT *
    FROM host_activity_reduced
    WHERE month_start = DATE_FORMAT(CURRENT_DATE, '%Y-%m')
),

-- Select today's metrics
today AS (
    SELECT *
    FROM daily_web_metrics
    WHERE date = CURRENT_DATE
    AND metric_name IS NOT NULL
)
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    -- Pad with NULLs for missing days
    COALESCE(y.metric_array, REPEAT(CAST(NULL AS INTEGER), CAST(DATE_DIFF('day', DATE_PARSE(y.month_start || '-01', '%Y-%m-%d'), CURRENT_DATE) - 1 AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
    DATE_FORMAT(CURRENT_DATE, '%Y-%m') AS month_start
FROM
    today t
        FULL OUTER JOIN yesterday y ON t.host = y.host
        AND t.metric_name = y.metric_name