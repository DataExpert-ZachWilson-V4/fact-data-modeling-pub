Insert into raj.host_activity_reduced
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
            month_start = '2023-02-01'
    ),
    today AS (
        SELECT
            host,
            metric_name,
            metric_array,
            month_start
        FROM
            raj.daily_web_metrics
        WHERE
            date = DATE('2023-02-02')
    )
SELECT
    COALESCE(t.host, y.host) as host,
    COALESCE(t.metric_name, y.metric_name),
    COALESCE(y.metric_array,REPEAT(null, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER))) || ARRAY[t.metric_value] as metric_array,
    '2023-02-02' as month_start
FROM
    today t
    FULL OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name


