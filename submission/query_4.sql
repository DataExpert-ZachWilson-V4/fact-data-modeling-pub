WITH today AS (
    -- Select data for the specified date
    SELECT *
    FROM malmarzooq80856.user_devices_cumulated
    WHERE date = DATE('2022-12-02')
),
generating_date_list AS (
    -- Generate a list of dates for each user and browser type
    SELECT 
        user_id,
        browser_type,
        sequence_date
    FROM today
    CROSS JOIN 
        UNNEST(SEQUENCE(DATE('2022-12-03'), DATE('2022-12-31'))) 
        AS t(sequence_date)
),
convert_date_to_int AS (
    -- Convert dates to integers using powers of 2 and sum them
    SELECT
        user_id,
        browser_type,
        CAST(
            SUM(
                CASE 
                    WHEN CONTAINS(dates_active, sequence_date) THEN 
                        CAST(POW(2, 31 - DATE_DIFF('day', sequence_date, DATE('2022-12-31'))) AS BIGINT)
                    ELSE 0 
                END
            ) AS BIGINT
        ) AS history_as_int
    FROM generating_date_list  
    GROUP BY  
        user_id,
        browser_type
)
SELECT 
    user_id,
    browser_type,
    TO_BASE(history_as_int, 2) AS activation_history,
    BIT_COUNT(history_as_int) AS total_active_days
FROM convert_date_to_int
