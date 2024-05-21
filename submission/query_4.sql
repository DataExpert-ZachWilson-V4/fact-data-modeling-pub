WITH TODAY AS(
    SELECT
        *
    FROM
        amaliah21315.user_devices_cumulated
    WHERE
        DATE = DATE('2021-01-20')
),
date_power_list_int AS (
    SELECT
        user_id,
        browser_type,
        CAST(
            SUM(
                CASE
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
                    ELSE 0
                END
            ) AS BIGINT
        ) AS date_power
    FROM
        today
        CROSS JOIN UNNEST (SEQUENCE(DATE('2021-01-19'), DATE('2021-01-20'))) AS t (sequence_date)
    GROUP BY
        user_id,
        browser_type
)
SELECT
    *,
    TO_BASE(date_power, 2) AS date_power_in_binary
FROM
    date_power_list_int