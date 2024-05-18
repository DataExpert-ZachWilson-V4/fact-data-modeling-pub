-- Today's data
WITH today AS (
    SELECT
        *
    FROM
        akshayjainytl54781.user_devices_cumulated
    WHERE
        date = DATE('2023-01-07')
),
-- CTE to hold generate integer representation of dates active
history_int_data AS (
    SELECT
        user_id,
        browser_type,
        CAST(
            -- Generate an integer representation of the dates active array by summing the items in the array
            -- when it's active, and 0 (when NULL) otherwise.
            SUM(
                CASE
                    -- Check if sequence date has the dates_active
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, date))
                    ELSE 0
                END
            ) AS BIGINT
        ) as history_int
    FROM
        today
        CROSS JOIN UNNEST(
            SEQUENCE(DATE ('2023-01-01'), DATE('2023-01-07'))
        ) as t(sequence_date)
    GROUP BY
        1,
        2
)
-- Converting to base-2 integer representation of dates active array
SELECT
    *,
    TO_BASE (history_int, 2) as active_history_binary, -- Convert to binary representation
    BIT_COUNT(history_int, 32) as num_days_active -- Count the number of 1s in the array to see number of days active
FROM
    history_int_data