INSERT INTO raj.host_activity_reduced
WITH
    yesterday AS (
        SELECT
            host,
            metric_name,
            metric_array,
            month_start
        FROM
            raj.host_activity_reduced
        WHERE
            month_start = '2023-01-01'
    ),
    today AS (
        SELECT
            host,
            metric_name,
            CAST(metric_value AS INTEGER) AS metric_value, -- Convert metric_value to INTEGER
            date
        FROM
            raj.daily_web_metrics
        WHERE
            date = DATE '2023-01-02'
    )
SELECT
    COALESCE(y.host, t.host) AS host,
    COALESCE(y.metric_name, t.metric_name) AS metric_name,
    COALESCE(
        y.metric_array,
        REPEAT(
            NULL,
            CAST(
                DATE_DIFF('day', DATE '2023-01-01', t.date) AS INTEGER
            )
        )
    ) || ARRAY[t.metric_value] AS metric_array,
    '2023-01-01' AS month_start
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host AND y.metric_name = t.metric_name
