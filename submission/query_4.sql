WITH
    today AS (
        SELECT
            *
        FROM
            barrocaeric.user_devices_cumulated
        WHERE
            date = DATE('2023-01-07')
    ),
    datelist_int AS (
        SELECT
            user_id,
            browser_type,
            TO_BASE(
                CAST(
                    SUM(
                        CASE
                            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                            ELSE 0
                        END
                    ) AS BIGINT
                ),
                2
            ) as history_int
        FROM
            today
            CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) as t (sequence_date)
        GROUP BY
            user_id,
            browser_type
    )
SELECT
    user_id,
    browser_type,
    -- Just to get the format right for the binary with a 32 mask
    LPAD(history_int, 32, '0') as history_binary
FROM
    datelist_int