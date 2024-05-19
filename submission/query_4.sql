-- User Devices Activity Int Datelist Implementation (query_4.sql)
-- This query converts the date list implementation into a base-2 integer datelist representation.

-- Step 1: Fetch today's data from user_devices_cumulated table
WITH today AS (
    SELECT * 
    FROM alissabdeltoro.user_devices_cumulated
    WHERE date = DATE '2023-01-02'
),

-- Step 2: Calculate history integer representation
date_list_int AS (
    SELECT 
        user_id,
        -- Calculate the history integer representation
        CAST(
            SUM(
                CASE 
                    WHEN ARRAY_JOIN(dates_active, ',') LIKE '%' || CAST(sequence_date AS VARCHAR) || '%' THEN 
                        POW(2, 30 - DATE_DIFF('day', sequence_date, DATE '2023-01-03'))
                    ELSE 0
                END
            ) AS BIGINT
        ) AS history_int
    FROM today
    -- Generate a sequence of dates from '2023-01-01' to '2023-01-02' and unnest them
    CROSS JOIN UNNEST(SEQUENCE(DATE '2023-01-01', DATE '2023-01-02')) AS t(sequence_date)
    GROUP BY user_id
),

-- Step 3: Select final fields with additional computations
final_output AS (
    SELECT 
        *,
        -- Convert history_int to binary representation
        TO_BASE(history_int, 2) AS history_in_binary,
        -- Count the number of active days using bitwise operation
        BIT_COUNT(history_int, 32) AS num_days_active
    FROM date_list_int
)

-- Select the final fields
SELECT *
FROM final_output
