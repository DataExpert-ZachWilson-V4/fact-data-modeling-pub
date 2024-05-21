WITH today AS (
    SELECT *
    FROM jsgomez14.user_devices_cumulated
    WHERE date = DATE('2023-01-04')
    -- We take the data from the last day cumulated. 
    -- Because it will have the most up-to-date information.
    -- And all the data we need to build a binary history.
),
date_list_int AS (
    SELECT
        user_id,
        browser_type,
        CAST(
            SUM(
                CASE
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                    ELSE 0
                END
            )
            AS BIGINT
        ) AS history_int
        -- Sums the powers of 2 for each date in the dates_active array.
        -- (We did 31 and not 32 bits, because one bit is the sign bit).
        -- This will get us a binary representation of the dates_active array.
        -- 1 if the date is present, 0 if it is not. From left to right most oldest to recent date.
    FROM today
    CROSS JOIN UNNEST(
            SEQUENCE(DATE('2023-01-01'), DATE('2023-01-04'))
        ) AS t(sequence_date)
        GROUP BY 1,2
)
SELECT
    *,
    TO_BASE(history_int, 2) AS history_in_binary
    -- Converts the integer to its binary string representation.
FROM date_list_int
