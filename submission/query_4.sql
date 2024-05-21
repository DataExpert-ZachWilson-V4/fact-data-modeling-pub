/* Building on top of the previous question, convert the date list implementation into the base-2 integer datelist representation as shown in the fact data modeling day 2 lab. */

WITH user_device_info AS (
-- load data from current date from user_devices_cumulated table
    SELECT 
        user_id,
        browser_type,
        dates_active,
        date
    FROM user_devices_cumulated
    WHERE date = DATE('2022-05-22')
),
-- CTE to record the integer datelist representation
date_list_int AS (
    SELECT 
        user_id,
        browser_type,
        -- capture a user's record for the 7 days of a week 
        -- calculate the power of 2 of the closest login date for current data
        CAST(SUM(
            CASE 
                WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                -- track if user didn't login during the week 
                ELSE 0 
            END
            ) AS BIGINT
        ) AS date_int
    FROM user_device_info
    CROSS JOIN UNNEST (SEQUENCE(DATE('2022-05-22'), DATE('2022-05-28'))) AS t(sequence_date)
    GROUP BY 
        user_id,
        browser_type
)
SELECT 
    user_id,
    browser_type,
    -- convert to base-2 for storage
    TO_BASE(date_int, 2) AS days_history_binary
FROM date_list_int