-- CONVERT THE DATE LIST IMPLEMENTATION INTO
-- THE BASE-2 INTEGER (0,1) DATE LIST REPRESENTATION AS SHOWN IN THE
-- FACT DATA MODELING DAY 2 LAB
WITH
    today AS (
        -- RETRIEVE ALL COLUMNS FROM 'user_devices_cumulated'
        -- TABLE FOR THE DATE '2023-01-02'
        SELECT
            *
        FROM
            user_devices_cumulated
        WHERE
            date = DATE('2023-01-02')
    ),
    date_list_int AS (
        -- SELECT user_id AND browser_type
        SELECT
            user_id,
            browser_type,
            -- CALCULATE AN INTEGER REPRESENTATION OF THE ACTIVE DATES
            CAST(
                SUM(
                    CASE
                        -- CHECK IF 'dates_active' CONTAINS THE 'sequence_date'
                        WHEN CONTAINS(dates_active, sequence_date) THEN
                            -- CALCULATE A BIT VALUE BASED ON THE POSITION OF THE DATE
                            POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS dates_active
        FROM
            today
            -- CROSS JOIN WITH A SEQUENCE OF DATES
            -- FROM '2023-01-01' TO '2023-01-02'
            CROSS JOIN UNNEST(
                SEQUENCE(DATE('2023-01-01'), DATE('2023-01-02'))
            ) AS t(sequence_date)
        GROUP BY
            -- GROUP BY user_id AND browser_type
            user_id,
            browser_type
    )
-- SELECT ALL COLUMNS FROM 'date_list_int' CTE
SELECT
    *,
    -- CONVERT THE INTEGER REPRESENTATION OF ACTIVE DATES TO A BINARY STRING
    TO_BASE(dates_active, 2) AS dates_in_binary
FROM
    date_list_int
