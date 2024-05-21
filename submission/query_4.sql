-- unnest the dates, and convert them into powers of 2
-- sum those powers of 2 in a group by on user_id and browser_type
-- convert the sum to base 2

-- Define a CTE (Common Table Expression) named 'today' to select data for a specific date
WITH today as
(
  SELECT *
  FROM user_devices_cumulated
  WHERE DATE = DATE('2023-01-07')
),
-- Define another CTE named 'date_list_int' to calculate an integer representation of user activity history
date_list_int AS (
    SELECT user_id,  -- Selecting the user_id 
    browser_type,    -- And selecting the browser type used by the user
    CAST(
    SUM(
        CASE WHEN CONTAINS
        (
            dates_active , sequence_date
        ) 
        THEN
            POW(2 ,30 - DATE_DIFF('day' , sequence_date , DATE)) -- Calculate a power of 2 based on the day difference
        ELSE 0 -- If the date is not contained in the activity dates, return 0
        END 
    ) AS BIGINT
    ) AS history_int  -- Cast the sum as a BIGINT and alias it as 'history_int'
    FROM today   -- Use the 'today' CTE as the source table
    CROSS JOIN 
    UNNEST(SEQUENCE(DATE('2023-01-01'),DATE('2023-01-07'))) as t(sequence_date)  -- Generate a sequence of dates from January 1 to January 7, 2023
    GROUP BY 1,2   -- Group by user ID and browser type
)
SELECT *,
TO_BASE(history_int , 2) as history_in_binary  -- Convert 'history_int' to a binary string and alias it as 'history_in_binary'
FROM date_list_int


