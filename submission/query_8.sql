-- Query to incrementally populate the host_activity_reduced table from a daily_web_metrics table

INSERT INTO shruthishridhar.host_activity_reduced
WITH 
    yesterday AS (
        SELECT * FROM shruthishridhar.host_activity_reduced
        WHERE month_start = '2021-01-02'
    ),
    today AS (
        SELECT * FROM shruthishridhar.daily_web_metrics -- recreated this table from w2 lab3 with host instead of user_id
        WHERE DATE = DATE('2021-01-03')
    )
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(
        y.metric_array, -- using yesterday's metric array if not null
        REPEAT(
            NULL,   -- create an array with NULL values if yesterday's metric_array is null
            CAST(DATE_DIFF('day', DATE('2021-01-03'), t.date) AS INTEGER)   -- calculate the length of the array based on the date difference
        )
    ) || ARRAY [t.metric_value] AS metric_array,    -- append today's metric_value to the array
    '2021-01-03' AS month_start
FROM today t FULL
OUTER JOIN yesterday y
ON t.host = y.host AND t.metric_name = y.metric_name