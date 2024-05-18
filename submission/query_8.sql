INSERT INTO
    jessicadesilva.host_activity_reduced
WITH
    --previously loaded data
    yesterday AS (
        SELECT
            *
        FROM
            jessicadesilva.host_activity_reduced
        WHERE
            month_start = '2023-08-01'
    ),
    --new data
    today AS (
        SELECT
            *
        FROM
            jessicadesilva.daily_web_metrics
        WHERE
            date = DATE('2023-08-03')
    )
    --append metric_value (possibly null) to metric_array if it exists, if not append
    --nulls equal to the number of days that have passed, then append new metric_value
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    CONCAT(
        COALESCE(
            y.metric_array,
            REPEAT(
                null,
                CAST(
                    DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
                )
            )
        ),
        ARRAY[t.metric_value]
    ) AS metric_array,
    '2023-08-01' AS month_start
FROM
    today t
    FULL OUTER JOIN yesterday y ON t.user_id = y.user_id
    AND t.metric_name = y.metric_name