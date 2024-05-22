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
            DATE = DATE('2023-08-04')
    )

SELECT
    COALESCE(
        yest.host,
        tod.host
    ) AS host,
    COALESCE(
        yest.metric_name,
        tod.metric_name
    ) AS metric_name,
    COALESCE(
        yest.metric_array,
        REPEAT(
            NULL,
            CAST(date_diff('day', DATE('2023-08-01'), tod.date) AS INTEGER))
        ) || ARRAY [tod.metric_value] AS metric_array,
        '2023-08-01' AS month_start
        FROM
            today tod full
            OUTER JOIN yesterday yest
            ON tod.host = yest.host
            AND tod.metric_name = yest.metric_name
