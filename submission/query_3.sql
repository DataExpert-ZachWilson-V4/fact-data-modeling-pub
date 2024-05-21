INSERT INTO
    RGINDALLAS.USER_DEVICES_CUMULATED (USER_ID, BROWSER_TYPE, DATES_ACTIVE, DATE)
    -- Step 1: Define the yesterday CTE to capture the state of user_devices_cumulated table for the previous day.
WITH
    YESTERDAY AS (
        SELECT
            *
        FROM
            RGINDALLAS.USER_DEVICES_CUMULATED
        WHERE
            DATE=DATE '2022-12-31'
    ),
    -- Step 2: Define the today CTE to capture events from the web_events table for the current day.
    TODAY AS (
        SELECT
            WE.USER_ID,
            D.BROWSER_TYPE,
            CAST(DATE_TRUNC('day', WE.EVENT_TIME) AS DATE) AS EVENT_DATE,
            COUNT(1) AS EVENT_COUNT
        FROM
            BOOTCAMP.WEB_EVENTS WE
            JOIN BOOTCAMP.DEVICES D ON WE.DEVICE_ID=D.DEVICE_ID
        WHERE
            DATE_TRUNC('day', WE.EVENT_TIME)=DATE '2023-01-01'
        GROUP BY
            WE.USER_ID,
            D.BROWSER_TYPE,
            CAST(DATE_TRUNC('day', WE.EVENT_TIME) AS DATE)
    ),
    -- Step 3: Insert into the user_devices_cumulated table by merging yesterday's data with today's data.
    MERGED_DATA AS (
        SELECT
            COALESCE(Y.USER_ID, T.USER_ID) AS USER_ID,
            COALESCE(Y.BROWSER_TYPE, T.BROWSER_TYPE) AS BROWSER_TYPE,
            CASE
                WHEN Y.DATES_ACTIVE IS NOT NULL THEN ARRAY[T.EVENT_DATE]||Y.DATES_ACTIVE
                ELSE ARRAY[T.EVENT_DATE]
            END AS DATES_ACTIVE,
            DATE '2023-01-01' AS DATE
        FROM
            YESTERDAY Y
            FULL OUTER JOIN TODAY T ON Y.USER_ID=T.USER_ID
            AND Y.BROWSER_TYPE=T.BROWSER_TYPE
    )
    -- Step 4: Insert the merged data into the user_devices_cumulated table
SELECT
    *
FROM
    MERGED_DATA
