INSERT INTO
    host_activity_reduced WITH yesterday AS (
        SELECT
            host,
            metric_name,
            metric_array,
            month_start
        FROM
            host_activity_reduced
        WHERE
            month_start = '2023-08-01' -- Selects data for the month '2023-08' and stores it in a CTE named yesterday.
    ),
    today AS (
        SELECT
            host,
            metric_name,
            metric_value,
            DATE
        FROM
            williampbassett.daily_web_metrics
        WHERE
            DATE = DATE('2023-08-02') -- Selects data from the daily_web_metrics table for the date '2023-08-02' and stores it in a CTE named today.
    )
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(
        y.metric_array,
        REPEAT(
            NULL,
            CAST(
                DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
            )
        )
    ) || ARRAY [t.metric_value] AS metric_array, -- If a record is appearing for the first time, fill in nulls for each day prior the metric was not measured.
    '2023-08-01' AS month_start -- Sets the month_start to '2023-08-01' for all inserted records.
FROM
    today t FULL
    OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name -- Performs a full outer join between yesterday and today based on the host and metric_name.