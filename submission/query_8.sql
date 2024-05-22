INSERT INTO grisreyesrios.host_activity_reduced

WITH yesterday AS (
        SELECT
            *
        FROM
            grisreyesrios.host_activity_reduced
        WHERE
            month_start = '2023-08-01'
    ),

    today AS (
        SELECT
            *
        FROM
            grisreyesrios.daily_web_metrics
        WHERE
            DATE = DATE('2023-08-02')
    )

SELECT
    COALESCE(
        y.host,
        t.host
    ) AS host,
    COALESCE(
        y.metric_name,
        t.metric_name
    ) AS metric_name,
    COALESCE(
        y.metric_array,
        REPEAT(
            NULL,
            CAST(date_diff('day', DATE('2023-08-01'), t.date) AS INTEGER))
        ) || ARRAY [t.metric_value] AS metric_array,
        '2023-08-01' AS month_start
        FROM
            today t full
            OUTER JOIN yesterday y
            ON t.host = y.host
            AND t.metric_name = y.metric_name
