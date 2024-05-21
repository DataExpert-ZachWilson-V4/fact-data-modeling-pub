-- convert the date list implementation (dates_active) into the base-2 integer representation 
WITH
    CURR AS (
        SELECT
            USER_ID,
            BROWSER_TYPE,
            DATES_ACTIVE,
            DATE
        FROM
            RGINDALLAS.USER_DEVICES_CUMULATED
        WHERE
            DATE=DATE('2021-01-31') -- @end_date of period we'd like to represent in base-2 integer representation; goal is to take dates_active and transform into more compact representation of history; this record has the history as an array of dates called dates_active
    ),
    CONVERSION AS (
        SELECT
            USER_ID,
            BROWSER_TYPE,
            CAST(
                CASE
                    WHEN CONTAINS(DATES_ACTIVE, SEQUENCE_DAY) THEN POW(
                        2,
                        30-DATE_DIFF('day', SEQUENCE_DAY, DATE) -- 30 will depend on the time period we would like to represent in binary; if it is n days we'd like to represent then fill in n - 1 here; since I'd like to do the month of January which has 31 days I have put 30 here; 
                    )
                    ELSE 0
                END AS BIGINT
            ) AS POWER_OF_TWO_REPR
        FROM
            CURR
            CROSS JOIN UNNEST (SEQUENCE(DATE('2021-01-01'), DATE('2021-01-31'))) AS T (SEQUENCE_DAY) --@start_date and @end_date of period we would like to represent history
    )
SELECT
    USER_ID,
    BROWSER_TYPE,
    TO_BASE(SUM(POWER_OF_TWO_REPR), 2) AS BINARY_REPRESENTATION_DATES_ACTIVE
FROM
    CONVERSION
GROUP BY
    USER_ID,
    BROWSER_TYPE
