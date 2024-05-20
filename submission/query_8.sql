CREATE
OR REPLACE TABLE DAILY_WEB_METRICS (
    HOST VARCHAR,
    METRIC_NAME VARCHAR,
    METRIC_ARRAY INTEGER,
    DATE VARCHAR
)
WITH
    (
        FORMAT='PARQUET',
        PARTITIONING=ARRAY['metric_name', 'date']
    );

INSERT INTO
    RGINDALLAS.HOST_ACTIVITY_REDUCED
WITH
    PREV AS (
        SELECT
            HOST,
            METRIC_NAME,
            METRIC_ARRAY,
            MONTH_START
        FROM
            RGINDALLAS.HOST_ACTIVITY_REDUCED
        WHERE
            MONTH_START='2021-01-01' -- @month_start
    ),
    CURR AS (
        SELECT
            HOST,
            METRIC_NAME,
            METRIC_VALUE,
            DATE
        FROM
            DAILY_WEB_METRICS
        WHERE
            DATE=DATE('2021-01-02') -- iterate through days in month in order
    )
SELECT
    COALESCE(P.HOST, C.HOST) AS HOST,
    COALESCE(P.METRIC_NAME, C.METRIC_NAME) AS METRIC_NAME,
    COALESCE(
        P.METRIC_ARRAY, -- if host already in host_cumulated then take previous metric_array and concat to add c.metric_value as last value in the array
        REPEAT( -- if host not already in host_cumulated then add null for every day since the beginning of the month that have already been accounted for (number of days current date is from month_start date) and then add c.metric_value as last value in the array
            NULL,
            CAST(
                DATE_DIFF('day', DATE('2021-01-01'), C.DATE) AS INTEGER -- date(@month_start) same @month_start as lines 13 & 38
            )
        )
    )||ARRAY[C.METRIC_VALUE] AS METRIC_ARRAY,
    '2021-01-01' AS MONTH_START -- @month_start
FROM
    PREV P
    FULL OUTER JOIN CURR C ON P.HOST=C.HOST
    AND P.METRIC_NAME=C.METRIC_NAME
    -- tag for feedback
