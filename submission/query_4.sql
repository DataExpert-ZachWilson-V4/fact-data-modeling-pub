WITH
    today AS (
        SELECT
            *
        FROM
            phabrahao.user_devices_cumulated
        WHERE
            DATE = DATE('2021-01-04')
    ),
    TRANSFORM AS (
        SELECT
            *,
            CAST(
                CASE
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE))
                    ELSE 0
                END AS BIGINT
            ) AS power2
        FROM
            today
            CROSS JOIN UNNEST (SEQUENCE(DATE('2021-01-02'), DATE('2021-01-04'))) AS t (sequence_date)
    ),
    encoded AS (
        SELECT
            user_id,
            browser_type,
            sum(power2) AS power2
        FROM
            TRANSFORM
        GROUP BY
            user_id,
            browser_type
    )
    
SELECT
    user_id,
    browser_type,
    to_base(power2, 2) AS binary
FROM
    encoded