WITH today AS (
    SELECT *
    FROM sagararora492.user_devices_cumulated
    WHERE date = DATE('2023-01-04')
    -- We are taking data from last day cumulated so we can build up the entire history
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
        -- Sums the powers of 2 for each date in the dates_active array. This will give us the binary representation.
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