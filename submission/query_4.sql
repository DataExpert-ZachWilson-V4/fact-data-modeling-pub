WITH today AS (
    SELECT *
    FROM dataste0.user_devices_cumulated
    WHERE date = DATE('2023-01-07')
),
date_list AS (
    SELECT
        user_id,
        browser_type,
        CAST(SUM(
            CASE WHEN CONTAINS(dates_active, sequence_date) 
                THEN POW(2, 30 - DATE_DIFF('day', sequence_date, date))
                ELSE 0
            END
        ) AS BIGINT) AS history_int
    FROM today
    CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-07'), DATE('2023-01-01'))) AS t(sequence_date)
    GROUP BY user_id, browser_type
)
SELECT
    user_id,
    browser_type,
    history_int,
    lpad(to_base(history_int, 2), 32, '0') AS binary_string
FROM date_list
