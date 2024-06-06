WITH
    -- Subquery to select data for the specified date
    today AS (
        SELECT
            *
        FROM
            bhakti.web_users_cumulated
        WHERE
            DATE = DATE('2023-01-07')
    ),
    -- Subquery to calculate the history_int value for each user
    date_list_int AS (
        SELECT
            user_id,
            CAST(
                SUM(
                    CASE
                        WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS history_int
        FROM
            today
            CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
        GROUP BY
            user_id
    )
-- Final query to select the results
SELECT
    *,
    TO_BASE(history_int, 2) AS history_in_binary, -- Convert history_int to binary
    BIT_COUNT(history_int, 32) AS num_days_active -- Count the number of active days
FROM
    date_list_int