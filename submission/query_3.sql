-- query to incrementally populate the cumulative user devices activity datelist table
-- min date in web_events table is '2021-01-02'
INSERT INTO
    RGINDALLAS.USER_DEVICES_CUMULATED
WITH
    PREV_DAY AS (
        SELECT
            *
        FROM
            RGINDALLAS.USER_DEVICES_CUMULATED
        WHERE
            DATE=DATE('2021-01-01') -- @start_date
    ),
    CURR_DAY AS (
        SELECT
            USER_ID,
            BROWSER_TYPE,
            CAST(EVENT_TIME AS DATE) AS EVENT_DATE,
            COUNT(1) AS EVENT_COUNT
        FROM
            BOOTCAMP.WEB_EVENTS W
            JOIN BOOTCAMP.DEVICES D ON W.DEVICE_ID=D.DEVICE_ID
        WHERE
            CAST(EVENT_TIME AS DATE)=DATE('2021-01-02') --@start_date + 1
        GROUP BY
            1,
            2,
            3
    )
SELECT
    COALESCE(C.USER_ID, P.USER_ID) AS USER_ID,
    COALESCE(C.BROWSER_TYPE, P.BROWSER_TYPE) AS BROWSER_TYPE,
    CASE
        WHEN P.DATES_ACTIVE IS NOT NULL
        AND C.EVENT_DATE IS NOT NULL THEN ARRAY[C.EVENT_DATE]||P.DATES_ACTIVE
        WHEN P.DATES_ACTIVE IS NOT NULL
        AND C.EVENT_DATE IS NULL THEN P.DATES_ACTIVE
        WHEN P.DATES_ACTIVE IS NULL THEN ARRAY[C.EVENT_DATE]
    END AS DATES_ACTIVE,
    COALESCE(C.EVENT_DATE, P.DATE+INTERVAL '1' DAY) AS DATE
FROM
    PREV_DAY P
    FULL OUTER JOIN CURR_DAY C ON P.USER_ID=C.USER_ID
    AND P.BROWSER_TYPE=C.BROWSER_TYPE
