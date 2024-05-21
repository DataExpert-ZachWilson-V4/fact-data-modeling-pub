    -- Subqueries:
    --     today: Selects records from alia.user_devices_cumulated for January 9, 2023.
    --     date_list_int: Calculates a numeric representation (history_int) for each user's activity over the past week (from January 2 to January 9, 2023). Each day’s activity is encoded as a power of 2 if the user was active that day.

    -- Main Query:
    --     Selects all columns from date_list_int.
    --     Converts history_int to a binary string (history_in_binary).
    --     Defines weekly_base as a binary string representing activity across 8 days.
    --     Counts the number of days the user was active in the past week (num_days_active).
    --     Checks if the user was active in the last three days by performing a bitwise AND operation and counting active bits (is_active_last_three_days).

WITH
    today AS (
        SELECT
            *
        FROM
            alia.user_devices_cumulated 
        WHERE
            DATE = DATE('2023-01-09')
    ),
    date_list_int AS (
        SELECT
            user_id,
            browser_type,
            CAST(
                SUM(
                    CASE
                        WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 8 - DATE_DIFF('day', sequence_date, DATE))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS history_int
        FROM
            today
            CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-02'), DATE('2023-01-09'))) AS t (sequence_date)
        GROUP BY
            user_id,
            browser_type
    )
SELECT
    *,
    TO_BASE(history_int, 2) AS history_in_binary,
    TO_BASE(FROM_BASE('11111111', 2), 2) AS weekly_base,
    BIT_COUNT(history_int, 64) AS num_days_active
FROM
    date_list_int