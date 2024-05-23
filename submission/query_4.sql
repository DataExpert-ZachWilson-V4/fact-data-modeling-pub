WITH
    today AS (

        SELECT
            *
        FROM
            halloweex.user_devices_cumulated
        WHERE
            date = DATE '2023-01-01'
    ),
    date_list_int AS (

        SELECT
            user_id,
            browser_type,

            CAST(
                SUM(
                    CASE

                        WHEN CONTAINS(dates_active, sequence_date) THEN

                        POW(2, 31 - DATE_DIFF('day', DATE '2023-01-01', sequence_date))
                        ELSE 0
                    END
                ) AS BIGINT
            ) AS dates_active
        FROM
            today

            CROSS JOIN UNNEST(
                SEQUENCE(DATE '2022-12-31', DATE '2023-01-01')
            ) AS t(sequence_date)
        GROUP BY

            user_id,
            browser_type
    )

SELECT
    *,

    TO_BASE(dates_active, 2) AS dates_in_binary
FROM
    date_list_int
