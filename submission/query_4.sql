WITH
    today AS (
        SELECT
            *
        FROM
            user_devices_cumulated
        WHERE
            date = DATE('2023-01-06')
    ),
    date_list_int AS (
        SELECT
            user_id,
            browser_type,
            CAST(
                SUM(
                    CASE
                    --if the active on that date, add 2^(index of date in list)
                        WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, date))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS history_int
        FROM
            today
            --gives list of all possible active dates that could be included in sum
            CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
        GROUP BY
            user_id,
            browser_type
    )
SELECT
    *,
    --convert integer back to binary
    TO_BASE(history_int, 2) AS history_in_binary
FROM
    date_list_int