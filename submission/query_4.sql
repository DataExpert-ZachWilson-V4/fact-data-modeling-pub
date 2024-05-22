WITH
    today AS (
        SELECT
            *
        FROM
            user_devices_cumulated
        WHERE
            DATE = DATE('2023-01-05')
    ),
    date_list_int as (
        SELECT
            user_id,
            CAST(
                SUM(
                    CASE
                        WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS history_int
        FROM
            today
            CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-05'))) AS t (sequence_date)
        GROUP BY
            user_id,
            browser_type
    )
SELECT
    *,
    TO_BASE(history_int, 2) AS base2
FROM
    date_list_int