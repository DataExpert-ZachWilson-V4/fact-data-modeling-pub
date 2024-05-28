-- Query to convert the date list implementation into the base-2 integer 
-- datelist representation
WITH 
    today AS (
        SELECT *
        FROM positivelyamber.user_devices_cumulated
        WHERE date = DATE('2022-12-31')
    ),
    date_list_int AS (
        SELECT 
            user_id,
            browser_type,
            CAST(SUM(
                CASE 
                    WHEN CONTAINS(dates_active, sequence_date) THEN
                    POW(2, 30 - DATE_DIFF('day', sequence_date, date))
                    ELSE 0
                END
            ) AS BIGINT) as history_int
        FROM today
        CROSS JOIN 
            UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) 
            AS t(sequence_date)
        GROUP BY 
            user_id, 
            browser_type
    )
SELECT 
    *, 
    TO_BASE(history_int, 2) AS history_in_binary,
    BIT_COUNT(history_int, 32) AS num_days_active
FROM date_list_int