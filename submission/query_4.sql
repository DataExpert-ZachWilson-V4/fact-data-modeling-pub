-- User Devices Activity Int Datelist Implementation (query_4.sql)
-- This query converts the date list implementation into a base-2 integer datelist representation.

-- Step 1: Fetch today's data from user_devices_cumulated table
WITH today AS (
    SELECT 
        user_id,
        browser_type,
        dates_active,
        date
    FROM 
        user_devices_cumulated
    WHERE 
        date = DATE '2023-01-07'
),

-- Step 2: Unnest the dates_active array and calculate the history integer representation
date_list_int AS (
    SELECT 
        user_id,
        browser_type,
        SUM(
            CASE 
                WHEN dates_active_element IS NOT NULL THEN CAST(POW(2, 30 - DATE_DIFF('day', dates_active_element, DATE '2023-01-07')) AS BIGINT)
                ELSE 0
            END
        ) AS history_int
    FROM 
        today
        CROSS JOIN UNNEST(dates_active) AS t(dates_active_element)
    GROUP BY 
        user_id, 
        browser_type
),

-- Step 3: Select final fields with additional computations
final_output AS (
    SELECT 
        user_id,
        browser_type,
        history_int,
        -- Convert history_int to binary representation
        TO_BASE(history_int, 2) AS history_in_binary,
        -- Count the number of active days using bitwise operation
        BIT_COUNT(history_int, 32) AS num_days_active
    FROM 
        date_list_int
)

-- Select the final fields
SELECT 
    user_id,
    browser_type,
    history_int,
    history_in_binary,
    num_days_active
FROM 
    final_output
ORDER BY 
    user_id, 
    browser_type
