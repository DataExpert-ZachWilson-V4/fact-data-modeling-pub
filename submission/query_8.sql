-- INSERT DATA INCREMENTALLY INTO THE 'host_activity_reduced' TABLE
-- USING THE 'daily_web_metrics' TABLE AS SHOWN IN THE FACT DATA MODELING DAY 3 LAB
INSERT INTO
    devpatel18.host_activity_reduced
WITH
    yesterday AS (
        -- SELECT ALL COLUMNS FROM 'host_activity_reduced' TABLE FOR THE MONTH STARTING '2023-08-01'
        SELECT
            *
        FROM
            devpatel18.host_activity_reduced
        WHERE
            month_start = '2023-08-01'
    ),
    today AS (
        -- SELECT ALL COLUMNS FROM 'daily_web_metrics' TABLE FOR THE DATE '2023-08-04'
        SELECT
            host,
            metric_name,
            metric_value,
            DATE '2023-08-04' AS date
        FROM
            devpatel18.daily_web_metrics
        WHERE
            DATE = DATE('2023-08-04')
    )
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    -- COMBINE METRIC ARRAYS FROM 'yesterday' AND 'today'
    CASE
        WHEN y.metric_array IS NOT NULL THEN y.metric_array || ARRAY[t.metric_value]
        ELSE ARRAY[
            -- IF 'y.metric_array' IS NULL, CREATE AN ARRAY WITH NULL VALUES
            REPEAT(
                NULL,
                -- CALCULATE THE DIFFERENCE IN DAYS BETWEEN '2023-08-01' AND 't.date' AND CAST IT AS INTEGER
                CAST(
                    DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
                )
            ) || ARRAY[t.metric_value]
        ]
    END AS metric_array,
    -- SET THE MONTH_START FOR THE INSERTED RECORDS TO '2023-08-01'
    '2023-08-01' AS month_start
FROM
    today t
    FULL OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name
