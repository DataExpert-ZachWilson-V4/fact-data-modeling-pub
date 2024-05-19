-- This query populates `user_devices_cumulated`, which stores a month's values of whether if user on a browser type is active on a day in a given 31 day window.
-- The values in teh array are in descending order meaning latest values comes first.

-- extract data for most recent date
WITH today AS (
    SELECT * 
    FROM shashankkongara.user_devices_cumulated
    WHERE date = DATE '2023-01-07'
),

-- CTE `date_list_int` calculates the binary history representation for each user and browser_type.
date_list_int AS (
    SELECT 
        user_id,
        browser_type,
        -- Calculate the history integer using bit manipulation based on active dates.
        CAST(SUM(
            CASE 
                -- If the date is active, calculate the power of 2 based on the date difference.
                -- In TRINO, the maximum value of an INTEGER is `2^31 - 1`, so we pass `30` as constant to POW function,
                WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE '2023-01-07'))
                ELSE 0 -- If the date is not active, add 0 to the sum.
            END
        ) AS BIGINT) AS history_int
    FROM today
    -- Cross join with a sequence of dates to check each day in the specified date range.
    CROSS JOIN UNNEST(
        SEQUENCE(DATE '2023-01-01', DATE '2023-01-07')
    ) AS t(sequence_date)
    GROUP BY user_id, browser_type
)

-- Final selection from `date_list_int` to get the user, browser, binary representation of history
SELECT
    *,
    -- Convert the history integer to a binary format
    -- TO_BASE(history_int, 2) AS history_in_binary,
    -- Padding ensures that the binary string is always 31 bits long, with each bit corresponding to a specific day of the month
    SUBSTRING(ARRAY_JOIN(REPEAT('0', 31), '') || TO_BASE(history_int, 2), -31) AS history_base2_string
    -- Count the number of '1's in the binary string to determine the number of active days.
    -- BIT_COUNT(history_int, 32) AS num_days_active
FROM
    date_list_int
