WITH
    today AS (
        -- Select all columns from 'user_devices_cumulated' table for the date '2023-01-02'
        SELECT
            *
        FROM
            halloweex.user_devices_cumulated
        WHERE
            date = DATE '2023-01-01'
    ),
    date_list_int AS (
        -- Select user_id and browser_type
        SELECT
            user_id,
            browser_type,
            -- Calculate an integer representation of the active dates
            CAST(
                SUM(
                    CASE
                    -- Check if 'dates_active' contains the 'sequence_date'
                        WHEN CONTAINS(dates_active, sequence_date) THEN
                        -- Calculate a bit value based on the position of the date
                        POW(2, 31 - DATE_DIFF('day', DATE '2023-01-01', sequence_date))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS dates_active
        FROM
            today
            -- Cross join with a sequence of dates from '2023-01-01' to '2023-01-02'
            CROSS JOIN UNNEST(
                SEQUENCE(DATE '2022-12-31', DATE '2023-01-01')
            ) AS t(sequence_date)
        GROUP BY
            -- Group by user_id and browser_type
            user_id,
            browser_type
    )
-- Select all columns from 'date_list_int' CTE
SELECT
    *,
    -- Convert the integer representation of active dates to a binary string
    TO_BASE(dates_active, 2) AS dates_in_binary
FROM
    date_list_int
