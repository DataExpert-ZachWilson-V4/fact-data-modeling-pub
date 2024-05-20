-- The query should insert the daily metrics from the `daily_web_metrics` table into the `host_activity_reduced` table.
INSERT INTO martinaandrulli.host_activity_reduced
WITH yesterday_host_activity_cte AS (
    -- Select the records from the `host_activity_reduced` table for the previous month
    SELECT *
    FROM martinaandrulli.host_activity_reduced
    WHERE month_start = '2021-01-01'
),
today_daily_metrics_cte AS (
    -- Select the records from the `daily_web_metrics` table for the current date
    SELECT *
    FROM martinaandrulli.daily_web_metrics
    WHERE date = DATE('2021-01-02')
)
SELECT
    -- Combine the host values from both tables, taking the non-null value
    COALESCE(tdm.host, yha.host) AS host,
    -- Combine the metric_name values from both tables, taking the non-null value
    COALESCE(tdm.metric_name, yha.metric_name) AS metric_name,
    -- Add today's value to the already existing array (from yesterday). If it's the first occurrence of the metric in the month, use an array of NULL
    COALESCE(yha.metric_array, REPEAT(NULL, CAST(DATE_DIFF('DAY', DATE('2021-01-01'), tdm.date) AS INTEGER))) || ARRAY[tdm.metric_value] AS metric_array,
    -- Set the month_start value to the first value of today's month
    DATE(date_trunc('month' , tdm.date)) AS month_start
FROM today_daily_metrics_cte AS tdm
FULL OUTER JOIN yesterday_host_activity_cte AS yha
ON tdm.host = yha.host AND tdm.metric_name = yha.metric_name
