WITH today AS (
    SELECT
        user_id,
        browser_type,
        dates_active,
        date
    FROM
        user_devices_cumulated
    WHERE
        date = DATE('2023-01-07') -- Selects data for '2023-01-07' and stores it in a CTE named today.
),
date_list_int AS (
    SELECT
        user_id,
        browser_type,
        CAST(
            SUM(
                CASE
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                    ELSE 0
                END
            ) AS BIGINT
        ) AS history_int -- Computes a numeric representation of the user's activity history within the specified date range.
    FROM
        today
        CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date) -- Generates a sequence of dates from '2023-01-01' to '2023-01-07' and performs a cross join with the 'today' CTE.
    GROUP BY
        user_id,
        browser_type
)
SELECT
    user_id,
    browser_type,
    history_int,
    TO_BASE(history_int, 2) AS history_in_binary -- Converts the numeric representation of the user's activity history to binary format.
FROM
    date_list_int -- Selects the user_id, browser_type, and computed history_int from the date_list_int CTE.
