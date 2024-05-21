INSERT INTO host_activity_reduced
WITH
yesterday AS (
    SELECT *
    FROM
        host_activity_reduced
    WHERE
        month_start = '2023-08-01'
),

today AS (
    SELECT *
    FROM
        daily_web_metrics
    WHERE
        date = DATE('2023-08-02')
)

SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(
        y.metric_array,
        REPEAT(
            null, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER)
        )
    )
    || array[t.metric_value] AS metric_array,
    '2023-08-01' AS month_start
FROM
    today AS t
FULL OUTER JOIN yesterday
    AS y ON t.host = y.host
AND t.metric_name = y.metric_name
