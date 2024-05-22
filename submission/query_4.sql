-- Query to convert the date list implementation into the base-2 integer datelist representation 

WITH
    today AS (
        SELECT * FROM shruthishridhar.user_devices_cumulated
        WHERE DATE = DATE('2021-01-09') -- earliest date in web_events tabl
    ),
    date_list_int AS (
        SELECT
            user_id,
            browser_type,
            CAST(
                SUM(
                    CASE
                        -- calculate the power of 2 based on the difference in days from the reference date if date is in dates_active array
                        WHEN CONTAINS (dates_active, sequence_date) THEN POW (2, 31 - DATE_DIFF ('day', sequence_date, DATE))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS history_int
        FROM today
        CROSS JOIN UNNEST ( -- Create a sequence of dates from '2021-01-02' to '2021-01-08'
            SEQUENCE (DATE ('2021-01-09'), DATE ('2021-01-16'))
        ) AS t (sequence_date)
        GROUP BY
            user_id,
            browser_type
    )
SELECT
    *,
    TO_BASE (history_int, 2) AS history_in_binary,  -- Convert the base-2 integer representation to a binary string
    TO_BASE (   -- Convert a predefined binary string back to a base-2 integer representation for weekly base
        FROM_BASE ('11111110000000000000000000000000', 2),
        2
    ) AS weekly_base,
    BIT_COUNT (history_int, 64) AS num_days_active, -- Count the number of active days
    BIT_COUNT ( -- Check if the user was active during the week
        BITWISE_AND (
            history_int,
            FROM_BASE ('11111110000000000000000000000000', 2)
        ),
        64
    ) > 0 AS is_weekly_active,
    BIT_COUNT ( -- Check if the user was active during the last week
        BITWISE_AND (
            history_int,
            FROM_BASE ('00000001111111000000000000000000', 2)
        ),
        64
    ) > 0 AS is_weekly_active_last_week,
    BIT_COUNT ( -- Check if the user was active in the last three days
        BITWISE_AND (
            history_int,
            FROM_BASE ('11100000000000000000000000000000', 2)
        ),
        64
    ) > 0 AS is_active_last_three_days
FROM date_list_int