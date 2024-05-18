INSERT INTO carloslaguna21592.host_activity_reduced
WITH
yesterday AS (
    SELECT
        host,
        metric_name,
        metric_array,
        month_start
    FROM carloslaguna21592.host_activity_reduced 
        WHERE month_start = '2023-08-01'
),
today AS ( 
    SELECT 
        host,
        metric_name,
        metric_value,
        date
    FROM carloslaguna21592.daily_web_metrics 
    WHERE date = DATE('2023-08-03')
    -- daily_web_metrics is created from bootcamp.web_events
)

SELECT
    t.host,
    COALESCE(y.metric_name, t.metric_name) AS metric_name,
    COALESCE(y.metric_array, 
        REPEAT(
            NULL, 
            CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER)
            -- '2023-08-01' is the absolute start date, not today nor yesterday
        )
    ) || -- Append today metric value
    ARRAY[t.metric_value] AS metric_array, 
    -- Create a new array with today's metric value (which is an int)
    '2023-08-01' AS month_start -- absolute start date
FROM yesterday y
FULL OUTER JOIN today t
ON 
y.host = t.host AND
y.metric_name = t.metric_name